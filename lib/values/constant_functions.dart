import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/size_config.dart';
import 'package:pchor_app/values/strings.dart';

class ConstantFunctions {
  static void showSnackBar(
    BuildContext context,
    Color color,
    Color textColor,
    String text,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  String hashSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: KColors.kWhiteColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                CircularProgressIndicator(color: KColors.kPrimaryColor),
                SizedBox(height: 20),
                Text(
                  Strings.loading,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Gradient defaultGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [KColors.kBackgroundColor, KColors.kShadowColor],
    );
  }

  static Gradient secondaryGradient() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [KColors.kPrimaryColor, KColors.kSecondaryColor],
    );
  }

  static BoxShadow defaultShadow() {
    return const BoxShadow(
      color: KColors.kShadowColor,
      spreadRadius: 3,
      blurRadius: 7,
      offset: Offset.zero,
    );
  }

  static BoxShadow defaultLightShadow({Offset offset = Offset.zero}) {
    return BoxShadow(
      color: const Color.fromARGB(255, 75, 74, 74),
      spreadRadius: 10,
      blurRadius: 8,
      offset: offset,
    );
  }

  static BoxShadow defaultBlackShadow({Offset offset = Offset.zero}) {
    return BoxShadow(
      color: const Color.fromARGB(255, 20, 20, 20).withValues(alpha: 0.6),
      spreadRadius: 10,
      blurRadius: 8,
      offset: offset,
    );
  }

  static BoxShadow defaultGreenShadow() {
    return const BoxShadow(
      color: KColors.kPrimaryColor,
      spreadRadius: 2,
      blurRadius: 6,
      offset: Offset.zero,
    );
  }

  static Route createRoute(Widget page, Offset offset) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = offset;
        const Offset end = Offset.zero;
        const Curve curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: Colors.black),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    vertical: getProportionateScreenWidth(15),
  ),
  enabledBorder: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  border: outlineInputBorder(),
);
