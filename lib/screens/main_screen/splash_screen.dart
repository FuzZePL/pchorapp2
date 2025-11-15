import 'package:flutter/material.dart';
import 'package:pchor_app/screens/login_screen/login_screen.dart';
import 'package:pchor_app/screens/main_screen/main_screen.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/values/size_config.dart';
import 'package:pchor_app/values/strings.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkIfLoginAndWant() {
    // sprawdzenie czy użytkownik jest już zalogowany, czyli czy zaznaczył nie wylogowuj sie
    return true;
    //return Server.isLogged();
  }

  void _moveAfterToMain(BuildContext ctx) async {
    Future.delayed(const Duration(milliseconds: 2900)).then((value) {
      if (!mounted) return;

      if (_checkIfLoginAndWant()) {
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveAfterToMain(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: ConstantFunctions.defaultGradient(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/app_icon.jpg',
              height: size.width * 0.65,
              width: size.width * 0.65,
            ),
            const SizedBox(height: 40),
            const Text(
              Strings.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: KColors.kTextColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
