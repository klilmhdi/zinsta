import 'package:flutter/material.dart';

class MessageItemWidget extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isMe;

  const MessageItemWidget({super.key, required this.message, required this.time, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              width: 230,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              decoration: BoxDecoration(
                color: isMe ? Colors.white : const Color.fromRGBO(112, 62, 254, 1),
                borderRadius: isMe
                    ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
                    : const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: isMe ? Colors.black : Colors.white,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0),
              child: Text(
                DateTime.now().toString(),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
