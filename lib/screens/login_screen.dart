import 'package:flutter/material.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _meCtrl = TextEditingController(text: 'Pablo');
  final _peerCtrl = TextEditingController(text: 'Marlene');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mensajería segura — Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Identifícate', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _meCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tu nombre (senderId)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _peerCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Destinatario (recipientId)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Entrar al chat'),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                currentUserId: _meCtrl.text.trim(),
                                peerUserId: _peerCtrl.text.trim(),
                              ),
                            ));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}