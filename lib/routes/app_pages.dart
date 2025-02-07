import 'package:flutter_getx_boilerplate/modules/modules.dart';
import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      children: [
        GetPage(
          name: Routes.onboard,
          page: () => const OnboardScreen(),
        ),
      ],
    ),
   
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}
