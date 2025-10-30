import 'package:flutter/material.dart';

class DialogFooterWidget extends StatelessWidget {
  final VoidCallback onClose;

  const DialogFooterWidget({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [TextButton(onPressed: onClose, child: const Text("닫기"))],
    );
  }
}
