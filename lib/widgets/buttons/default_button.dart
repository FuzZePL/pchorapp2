import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/widgets/buttons/ink_well_rounded.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.defaultSize,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.gradient,
    this.child,
  });
  final VoidCallback onTap;
  final double defaultSize;
  final Gradient gradient;
  final String text;
  final IconData icon;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (child != null) child!,
          InkWellRounded(
            radius: 12,
            shadow: ConstantFunctions.defaultShadow(),
            onTap: onTap,
            gradient: gradient,
            child: Container(
              height: defaultSize * 5.5,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: KColors.kWhiteColor,
                    ),
                  ),
                  SizedBox(width: defaultSize),
                  Icon(icon, size: 24, color: KColors.kWhiteColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
