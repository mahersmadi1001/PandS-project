import 'package:flutter/material.dart';

class VisibilityPassword extends StatefulWidget {
  const VisibilityPassword({super.key});

  @override
  State<VisibilityPassword> createState() => _VisibilityPasswordState();
}

class _VisibilityPasswordState extends State<VisibilityPassword> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        visibility_password
            ? Icons.visibility_off_rounded
            : Icons.visibility_outlined,
      ),
      onPressed: () {
        setState(() {
          visibility_password = !visibility_password;
        });
      },
    );
  }
}
