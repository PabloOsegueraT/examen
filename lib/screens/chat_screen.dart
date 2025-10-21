import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/chat_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  final String peerUserId;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.peerUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(
        currentUserId: currentUserId,
        peerUserId: peerUserId,
      )..init(),
      child: const _ChatScreenView(),
    );
  }
}

class _ChatScreenView extends StatefulWidget {
  const _ChatScreenView();

  @override
  State<_ChatScreenView> createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<_ChatScreenView> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final isLoading = provider.loading;
    final messages = provider.messages;
    final me = provider.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat — ${provider.currentUserId} ⇄ ${provider.peerUserId}'),
      ),
      body: Column(
        children: [
          if (isLoading)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: ListView.separated(
              controller: _scrollCtrl,
              reverse: true, // mensajes recientes arriba
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final m = messages[i];
                final mine = m.senderId == me;
                return MessageBubble(
                  text: m.text,
                  sender: m.senderId,
                  date: m.createdAt,
                  mine: mine,
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje…',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _send(provider),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _send(provider),
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send(ChatProvider p) async {
    final txt = _textCtrl.text.trim();
    if (txt.isEmpty) return;
    final ok = await p.send(txt);
    if (ok) {
      _textCtrl.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo enviar.')),
        );
      }
    }
  }
}