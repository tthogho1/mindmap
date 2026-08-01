// Command mindmap-server runs the local gRPC core for the mind map app.
package main

import (
	"flag"
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

	go func() {
		sig := make(chan os.Signal, 1)
		signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
		<-sig
		log.Println("shutting down")
		srv.GracefulStop()
	}()

	log.Printf("mindmap gRPC server listening on %s", *addr)
	if err := srv.Serve(lis); err != nil {
		log.Fatalf("serve: %v", err)
	}
}
