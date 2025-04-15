import 'package:elfarouk_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class LogoAnimation extends StatelessWidget {
  final bool logoVisible;
  final Animation<double> verticalAnimation;
  final Animation<double> horizontalAnimation;
  final Animation<double> scaleAnimation;

  const LogoAnimation({
    super.key,
    required this.logoVisible,
    required this.verticalAnimation,
    required this.horizontalAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        verticalAnimation,
        horizontalAnimation,
      ]),
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: logoVisible ? 1.0 : 0,
          child: Transform.translate(
            offset: Offset(horizontalAnimation.value, verticalAnimation.value),
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: Image.asset(Assets.logo),
            ),
          ),
        );
      },
    );
  }
}