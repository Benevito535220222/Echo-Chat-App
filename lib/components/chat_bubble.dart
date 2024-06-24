import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String image;
  final bool isReply;

  const ChatBubble(
      {Key? key,
      required this.message,
      required this.image,
      this.isReply = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isReply
            ? const Color.fromARGB(255, 48, 48, 48)
            : Color.fromARGB(255, 223, 222, 221),
      ),
      child: Column(
        children: [
          if (image != '') ...[
            Text(
              message,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 3, 3, 3)),
            ),
            Image.network(image),
          ] else ...[
            Text(
              message,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 9, 9, 9)),
            ),
          ],
        ],
      ),
    );
  }
}
