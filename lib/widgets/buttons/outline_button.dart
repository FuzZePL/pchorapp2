import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';

class OutlineButtonOwn extends StatelessWidget {
  const OutlineButtonOwn({
    super.key,
    required this.defaultSize,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.width,
  });
  final VoidCallback onTap;
  final double defaultSize;
  final String text;
  final IconData icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: defaultSize * 5.5,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: KColors.kBackgroundColor,
          border: Border.all(width: 2, color: KColors.kTextColorLight),
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
                color: KColors.kTextColorLight,
              ),
            ),
            SizedBox(width: defaultSize),
            Icon(icon, size: 24, color: KColors.kTextColorLight),
          ],
        ),
      ),
    );
  }
}
