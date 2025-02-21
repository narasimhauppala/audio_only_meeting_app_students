import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/app_constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnected = false;

  Future<WebSocketChannel> connect(String token) async {
    try {
      final uri = Uri.parse('${AppConstants.socketUrl}?token=$token');
      _channel = WebSocketChannel.connect(
        uri,
        protocols: ['websocket'],
      );
      _isConnected = true;
      return _channel!;
    } catch (e) {
      _isConnected = false;
      rethrow;
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }

  void emit(String event, dynamic data) {
    if (!_isConnected || _channel == null) {
      throw Exception('WebSocket not connected');
    }
    _channel!.sink.add({
      'event': event,
      'data': data,
    });
  }

  Stream? get stream => _channel?.stream;
  bool get isConnected => _isConnected;
} 