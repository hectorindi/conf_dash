import 'package:flutter/material.dart';
import 'package:admin/core/constants/color_constants.dart';
import 'chat_popup.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showChatPopup() {
    _overlayEntry = OverlayEntry(
      builder: (context) => ChatPopup(
        onClose: _closeChatPopup,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeChatPopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Material(
        type: MaterialType.transparency,
        child: FloatingActionButton(
          onPressed: _showChatPopup,
          backgroundColor: primaryColor,
          child: Icon(
            Icons.chat_bubble,
            color: Colors.white,
          ),
          heroTag: "chat_button",
        ),
      ),
    );
  }
}