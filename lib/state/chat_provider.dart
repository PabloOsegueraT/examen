import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../core/config.dart';
import '../models/message.dart';
import '../services/api_client.dart';

class ChatProvider extends ChangeNotifier {
  final String currentUserId;
  final String peerUserId;

  ChatProvider({required this.currentUserId, required this.peerUserId});

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  late final ApiClient _api;
  WebSocketChannel? _channel;
  StreamSubscription? _wsSub;

  bool _started = false;
  bool _connecting = false;
  int _retries = 0;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> init() async {
    if (_started) return;  // 👈 evita doble init
    _started = true;

    _api = ApiClient(currentUserId);

    _loading = true;
    notifyListeners();

    final initial = await _api.fetchMessages();
    _messages
      ..clear()
      ..addAll(initial.where((m) =>
      (m.senderId == currentUserId && m.recipientId == peerUserId) ||
          (m.senderId == peerUserId && m.recipientId == currentUserId)));

    _loading = false;
    notifyListeners();

    _connectWs();
  }

  void _connectWs() {
    if (_connecting) return;  // 👈 evita conexiones simultáneas
    _connecting = true;

    final delayMs = (_retries == 0) ? 0 : (800 * _retries).clamp(800, 6000);
    Future.delayed(Duration(milliseconds: delayMs), () {
      try {
        _channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));
        _wsSub = _channel!.stream.listen((data) {
          _retries = 0; // estable
          final msg = ChatMessage.fromJson(jsonDecode(data));
          final relevant =
              (msg.recipientId == currentUserId && msg.senderId == peerUserId) ||
                  (msg.senderId == currentUserId && msg.recipientId == peerUserId);
          if (relevant) {
            _messages.insert(0, msg);
            notifyListeners();
          }
        }, onError: (_) {
          _scheduleReconnect();
        }, onDone: () {
          _scheduleReconnect();
        });
      } catch (_) {
        _scheduleReconnect();
      } finally {
        _connecting = false;
      }
    });
  }

  void _scheduleReconnect() {
    _wsSub?.cancel();
    _channel?.sink.close();
    _wsSub = null;
    _channel = null;
    _retries = (_retries + 1).clamp(1, 6);
    _connectWs();
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  Future<bool> send(String text) async {
    final ok = await _api.sendMessage(recipientId: peerUserId, text: text.trim());
    return ok;
  }
}