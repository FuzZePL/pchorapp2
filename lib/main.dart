import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pchor_app/screens/auth_screen/register_screen.dart';
import 'package:pchor_app/screens/login_screen/login_screen.dart';
import 'package:pchor_app/screens/main_screen/main_screen.dart';
import 'package:pchor_app/screens/main_screen/splash_screen.dart';
import 'package:pchor_app/values/colors.dart';
import 'package:pchor_app/values/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: KColors.kPrimaryColor),
        useMaterial3: true,
        fontFamily: 'SamsungOne',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
      localizationsDelegates: const [
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      routes: {
        MainScreen.routeName: (_) => const MainScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
      },
    );
  }
}
