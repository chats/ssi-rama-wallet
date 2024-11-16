import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class AcapyWebSocket {
  late WebSocketChannel channel;
  final void Function(dynamic) onMessageCallback;
  final String wsUrl;
  bool isConnected = false;

  AcapyWebSocket({
    required this.wsUrl,
    required this.onMessageCallback,
  });

  void connect() {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
      );
      
      channel.stream.listen(
        (message) {
          final decodedMessage = jsonDecode(message);
          onMessageCallback(decodedMessage);
        },
        onDone: () {
          isConnected = false;
          print('WebSocket connection closed');
        },
        onError: (error) {
          isConnected = false;
          print('WebSocket error: $error');
          // Implement reconnection logic here if needed
        },
      );
      
      isConnected = true;
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      isConnected = false;
    }
  }

  void disconnect() {
    if (isConnected) {
      channel.sink.close();
      isConnected = false;
    }
  }
}