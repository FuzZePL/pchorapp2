import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/values/size_config.dart';
import 'package:pchor_app/widgets/buttons/ink_well_rounded.dart';

class OnBackPressed extends StatelessWidget {
  const OnBackPressed({
    super.key,
    required this.icon,
    required this.onBackPressed,
  });
  final IconData icon;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final double defaultSize = SizeConfig.defaultSize!;
    return SizedBox(
      height: defaultSize * 5.5,
      width: defaultSize * 5.5,
      child: InkWellRounded(
        radius: 12,
        shadow: const BoxShadow(color: KColors.kBackgroundColor),
        onTap: onBackPressed,
        color: KColors.kBackgroundColor,
        child: Container(
          width: defaultSize * 5.5,
          height: defaultSize * 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: ConstantFunctions.secondaryGradient(),
            boxShadow: const [
              BoxShadow(
                color: KColors.kShadowColor,
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: KColors.kBackgroundColor),
        ),
      ),
    );
  }
}
