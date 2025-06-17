import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
    this.icon,
  });

  final String title;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
          ),
          if (icon != null) ...[
            const SizedBox(width: 8), // Khoảng cách giữa text và icon
            Icon(icon),
          ]
        ],
      ),
    );
  }
}
