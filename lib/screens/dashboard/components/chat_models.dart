import 'dart:typed_data';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool hasImage;
  final Uint8List? imageBytes;
  final bool hasGeneratedImage;
  final String? generatedImageUrl;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.hasImage = false,
    this.imageBytes,
    this.hasGeneratedImage = false,
    this.generatedImageUrl,
  });
}