import 'package:flutter/material.dart';
import '../uivalue.dart';

class DialogHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const DialogHeaderWidget({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: UIValue.largeFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: -8,
          child: IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            splashRadius: 20,
          ),
        ),
      ],
    );
  }
}
