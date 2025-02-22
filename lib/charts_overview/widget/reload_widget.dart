import 'package:flutter/material.dart';

class ReloadWidget extends StatelessWidget {
  final String content;
  final VoidCallback? onPressed;
  final String image;
  final Color? iconColor;

  const ReloadWidget({
    super.key,
    required this.content,
    required this.onPressed,
    this.iconColor,
  })  : image = "assets/images/no_data.png";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
              opacity: 0.5,
              child: Image.asset(image, width: 100, height: 100)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              content,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          if (onPressed != null)
            const Icon(Icons.refresh),
        ],
      ),
    );
  }
}
