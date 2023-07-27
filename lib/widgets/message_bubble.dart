import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final Key? mykey;
  final String username;
  final String message;
  final bool isMe;

  // ignore: use_key_in_widget_constructors
  const MessageBubble(
      {this.mykey,
      required this.username,
      required this.message,
      required this.isMe});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: widget.message.length < 40
              ? widget.message.length.toDouble() * 10
              : MediaQuery.of(context).size.width * 0.7,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: widget.isMe
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: Radius.circular(widget.isMe ? 10 : 2),
                  bottomRight: Radius.circular(widget.isMe ? 2 : 10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.username,
                style: TextStyle(
                    color: widget.isMe ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                widget.message,
                style:
                    TextStyle(color: widget.isMe ? Colors.black : Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }
}
