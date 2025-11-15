import 'package:flutter/material.dart';

class InkWellRounded extends StatelessWidget {
  const InkWellRounded({
    super.key,
    required this.child,
    required this.radius,
    required this.shadow,
    required this.onTap,
    this.color,
    this.gradient,
  });
  final Widget child;
  final double radius;
  final BoxShadow shadow;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [shadow],
        borderRadius: BorderRadius.circular(radius),
        gradient: gradient,
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              radius,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
