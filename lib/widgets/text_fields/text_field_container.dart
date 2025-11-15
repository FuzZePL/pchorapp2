import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/size_config.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(5),
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: KColors.kTextFieldColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: KColors.kShadowColor,
            blurRadius: 8,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: child,
    );
  }
}
