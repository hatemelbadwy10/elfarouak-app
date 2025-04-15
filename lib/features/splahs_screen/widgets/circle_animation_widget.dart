import 'package:flutter/cupertino.dart';

class CircleAnimation extends StatelessWidget {
  final bool isShrunk;

  const CircleAnimation({super.key, required this.isShrunk});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isShrunk ? 50 : 150,
      height: isShrunk ? 50 : 150,
      decoration: const BoxDecoration(
        color: Color(0xFF003366),
        shape: BoxShape.circle,
      ),
    );
  }
}
