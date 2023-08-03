import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  String? type;
  MyTextField(
      {required this.controller, required this.label, this.type, super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            obscureText: widget.type == 'pass' ? !_isChecked : false,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: widget.label,
              focusedBorder: const UnderlineInputBorder(),
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
        widget.type == 'pass'
            ? Checkbox(
                value: _isChecked,
                onChanged: (val) {
                  setState(() {
                    _isChecked = val!;
                  });
                })
            : Container()
      ],
    );
  }
}
