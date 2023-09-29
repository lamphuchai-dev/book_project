import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/pages/home/home.dart';
import 'package:u_book/pages/book/detail_book/detail_book.dart';

class Routes {
  static const initialRoute = "/";
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      // case RouterName.home:
      case "/":
        return PageTransition(
            settings: settings,
            child: const HomeView(),
            type: PageTransitionType.rightToLeft);
      case RoutesName.detailBook:
        assert(args != null && args is Book, "args must be Book");
        return PageTransition(
            settings: settings,
            child: DetailBookView(
              book: args as Book,
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
