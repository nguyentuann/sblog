import 'package:flutter/material.dart';

class CommonAvatar extends StatelessWidget {
  const CommonAvatar({
    super.key,
    required this.url,
    required this.size,
    this.onTap,
  });

  final String url;
  final double size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Giữ hình tròn
          border: Border.all(
            color: Colors.blue, // Màu viền
            width: 3, // Độ dày viền
          ),
        ),
        padding: const EdgeInsets.all(3), // Khoảng cách giữa viền và ảnh
        child: ClipRRect(
          borderRadius: BorderRadius.circular(120),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/avt.jpg', // Ảnh thay thế trong assets
              fit: BoxFit.contain,
              width: size,
              height: size,
            ),
          ),
        ),
      ),
    );
  }
}
