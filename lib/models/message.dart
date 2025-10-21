class ChatMessage {
  final String id;          // Puede venir vacío si es de WS sin id
  final String senderId;
  final String recipientId;
  final String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['id'] ?? '').toString(),
      senderId: (json['senderId'] ?? '').toString(),
      recipientId: (json['recipientId'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      createdAt: _parseTs(json['createdAt']),
    );
  }

  static DateTime _parseTs(dynamic ts) {
    // Backend envía ts como epoch (ms) o ISO; soportamos ambos:
    if (ts == null) return DateTime.now();
    if (ts is int) return DateTime.fromMillisecondsSinceEpoch(ts);
    if (ts is String) {
      // intentar parseo ISO
      try { return DateTime.parse(ts); } catch (_) {}
      // intentar parseo numérico
      final num? n = num.tryParse(ts);
      if (n != null) return DateTime.fromMillisecondsSinceEpoch(n.toInt());
    }
    return DateTime.now();
  }
}