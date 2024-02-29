import 'package:dog_app/features/home/screen/home_screen.dart';
import 'package:dog_app/features/settings/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Keys {
  static GlobalKey<NavigatorState> mainNav = GlobalKey();
}

class AppRoutes {
  static GoRouter router = GoRouter(
    navigatorKey: Keys.mainNav,
    routes: [
      GoRoute(path: HomeScreen.route,builder: (context, state) =>const HomeScreen(),),
      GoRoute(path: SettingScreen.route,builder: (context, state) =>const SettingScreen(),)  
    ]
  );
}
