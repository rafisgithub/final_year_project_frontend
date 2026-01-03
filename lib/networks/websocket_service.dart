import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'endpoints.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _streamController.stream;
  bool get isConnected => _channel != null;

  void connect(int senderId, int receiverId) {
    disconnect();
    final url = '$websocketUrl$senderId/$receiverId/';

    try {
      print('🔌 [WebSocket] Connecting to: $url');
      print('🔌 [WebSocket] Sender ID: $senderId, Receiver ID: $receiverId');

      _channel = WebSocketChannel.connect(Uri.parse(url));
      print('✅ [WebSocket] Connection initiated');

      _channel!.stream.listen(
        (message) {
          print('📨 [WebSocket] Raw message received: $message');
          try {
            final decoded = jsonDecode(message);
            print('✅ [WebSocket] Decoded message: $decoded');
            _streamController.add(decoded);
          } catch (e) {
            print('❌ [WebSocket] Decode Error: $e');
            print('❌ [WebSocket] Failed message: $message');
          }
        },
        onError: (error) {
          print('❌ [WebSocket] Stream Error: $error');
        },
        onDone: () {
          print('⚠️ [WebSocket] Connection closed');
        },
      );
    } catch (e) {
      print('❌ [WebSocket] Connection Error: $e');
    }
  }

  void sendMessage(String text, {String type = 'chat_message'}) {
    if (_channel == null) {
      print('❌ [WebSocket] Cannot send - not connected');
      return;
    }

    final payload = {'message': text, 'type': type};
    final jsonPayload = jsonEncode(payload);

    print('📤 [WebSocket] Sending message: $jsonPayload');
    try {
      _channel!.sink.add(jsonPayload);
      print('✅ [WebSocket] Message sent successfully');
    } catch (e) {
      print('❌ [WebSocket] Send error: $e');
    }
  }

  void sendTyping(bool isTyping) {
    if (_channel != null) {
      final payload = jsonEncode({
        'type': isTyping ? 'typing_start' : 'typing_stop',
      });
      print('⌨️ [WebSocket] Sending typing: $payload');
      _channel!.sink.add(payload);
    }
  }

  void disconnect() {
    if (_channel != null) {
      print('🔌 [WebSocket] Disconnecting...');
      _channel!.sink.close(status.normalClosure);
      _channel = null;
    }
  }

  void dispose() {
    print('🗑️ [WebSocket] Disposing service');
    disconnect();
    _streamController.close();
  }
}
