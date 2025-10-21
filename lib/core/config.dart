class AppConfig {
  // url
  static const String baseUrl = "https://intramuscular-sportier-delilah.ngrok-free.dev";

  static String get wsUrl {
    final u = Uri.parse(baseUrl); // https://sub.ngrok-free.dev (sin / final)
    // Construye wss://host[:port]/ws/messages sin poner puerto 0
    return Uri(
      scheme: (u.scheme == 'https') ? 'wss' : 'ws',
      host: u.host,
      port: u.hasPort ? u.port : null, // <-- crítico: NO pongas 0
      path: '/ws/messages',
    ).toString();
  }

  static String get messagesPost => "$baseUrl/api/messages";
  static String get messagesGet  => "$baseUrl/api/messages?limit=50";
}