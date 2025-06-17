import 'package:flutter/material.dart';

class InforBar extends StatelessWidget {
  const InforBar({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 30),
        Text(title),
        const Spacer(),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.arrow_right_outlined,
          ),
        ),
      ],
    );
  }
}
