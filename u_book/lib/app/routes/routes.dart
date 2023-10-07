import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/pages/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:u_book/pages/book/detail_book/detail_book.dart';
import 'package:u_book/pages/book/chapters/chapters.dart';
import 'package:u_book/pages/book/read_book/read_book.dart';
import 'package:u_book/pages/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:u_book/pages/splash/splash.dart';

class Routes {
  static const initialRoute = "/";
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case initialRoute:
        return PageTransition(
            settings: settings,
            child: const SplashView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.bottomNav:
        return PageTransition(
            settings: settings,
            child: const BottomNavigationBarView(),
            type: PageTransitionType.rightToLeft);

      case RoutesName.detailBook:
        assert(args != null && args is Book, "args must be Book");
        return PageTransition(
            settings: settings,
            child: DetailBookView(
              book: args as Book,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.chaptersBook:
        assert(args != null && args is Book, "args must be Book");
        return PageTransition(
            settings: settings,
            child: ChaptersView(
              book: args as Book,
            ),
            type: PageTransitionType.rightToLeft);

      case RoutesName.readBook:
        assert(
            args != null && args is Map<String, dynamic>, "args must be Book");

        args as Map;
        return PageTransition(
            settings: settings,
            child: ReadBookView(
              book: args["book"]!,
              chapter: args["chapter"],
            ),
            type: PageTransitionType.rightToLeft);

      default:
        return _errRoute();
    }
  }

  static Route<dynamic> _errRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("No route")),
              body: const Center(
                child: Text("no route"),
              ),
            ));
  }
}
