import 'package:flutter/material.dart';

class TextAnimation extends StatelessWidget {
  final Animation<double> verticalAnimation;
  final Animation<double> opacityAnimation;

  const TextAnimation({
    super.key,
    required this.verticalAnimation,
    required this.opacityAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: verticalAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, verticalAnimation.value),
          child: FadeTransition(
            opacity: opacityAnimation,
            child:  Text(
              'الفاروق',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
