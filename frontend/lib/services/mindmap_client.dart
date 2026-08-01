import 'package:grpc/grpc.dart';

import '../generated/mindmap.pbgrpc.dart';

/// Thin wrapper that owns the gRPC channel to the local Go core and exposes the
/// generated stub. The channel is insecure because it never leaves localhost.
class MindMapClient {
  MindMapClient({this.host = '127.0.0.1', this.port = 50051}) {
    _channel = ClientChannel(
      host,
      port: port,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        idleTimeout: Duration(minutes: 5),
      ),
    );
    stub = MindMapServiceClient(_channel);
  }

  final String host;
  final int port;
  late final ClientChannel _channel;
  late final MindMapServiceClient stub;

  Future<void> shutdown() => _channel.shutdown();
}
