// Command mindmap-server runs the local gRPC core for the mind map app.
package main

import (
	"flag"
	"io"
	"log"
	"net"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"

	"mindmap/internal/service"
	"mindmap/internal/store"

	mmv1 "mindmap/gen/mindmapv1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func defaultDataDir() string {
	if home, err := os.UserHomeDir(); err == nil {
		return filepath.Join(home, ".mindmap", "maps")
	}
	return "maps"
}

func main() {
	addr := flag.String("addr", "127.0.0.1:50051", "gRPC listen address")
	dataDir := flag.String("data-dir", defaultDataDir(), "directory for map JSON files")
	exitWithParent := flag.Bool("exit-with-parent", false, "shut down when stdin closes (set by the desktop app that launches the server)")
	flag.Parse()

	st, err := store.New(*dataDir)
	if err != nil {
		log.Fatalf("init store: %v", err)
	}
	log.Printf("data directory: %s", *dataDir)

	lis, err := net.Listen("tcp", *addr)
	if err != nil {
		log.Fatalf("listen %s: %v", *addr, err)
	}

	srv := grpc.NewServer()
	mmv1.RegisterMindMapServiceServer(srv, service.New(st))
	reflection.Register(srv) // enables grpcurl / debugging

	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, syscall.SIGINT, syscall.SIGTERM)
	if *exitWithParent {
		// The launching app holds the other end of our stdin pipe. It closes
		// whenever that app exits — even on a crash — so we never outlive it.
		go func() {
			_, _ = io.Copy(io.Discard, os.Stdin)
			log.Println("parent exited")
			shutdown <- syscall.SIGTERM
		}()
	}
	go func() {
		<-shutdown
		log.Println("shutting down")
		srv.GracefulStop()
	}()

	log.Printf("mindmap gRPC server listening on %s", *addr)
	if err := srv.Serve(lis); err != nil {
		log.Fatalf("serve: %v", err)
	}
}
