import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  _initScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    if (Platform.isIOS) {
      FlutterNativeSplash.remove();
    }
    await Future.delayed(const Duration(milliseconds: 300));
    NavigatorHelper.toHome();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return const Scaffold(
      body: Center(
        child: Text("Welcome to SplashScreen"),
      ),
    );
  }
}
