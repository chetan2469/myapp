import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimationDemo extends StatelessWidget {
  const AnimationDemo({super.key});

  Widget imageWidget() {
    return SizedBox(
      height: 60,
      width: 60,
      child: Image.asset("assets/aviator-plane.png"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: imageWidget()
          .animate()
          .moveY(begin: 100, end: 10, duration: 5000.ms)
          .moveX(begin: 10, end: 350, duration: 5000.ms)
          .then()
      // .moveY(begin: 350, end: 20, duration: 5000.ms)
      // .moveX(begin: 20, end: 100, duration: 5000.ms)
      // .moveY(delay: 5000.ms, end: 150, duration: 5000.ms)
      // .moveX(delay: 5000.ms, begin: 0, duration: 5000.ms)
      // .shake(hz: 1, curve: Curves.bounceIn)
      // .hide(delay: 200.ms)
      // .shimmer(delay: 400.ms, duration: 3000.ms)
      // .shake(hz: 4, curve: Curves.easeInOutCubic),
      ,
    );
  }
}
