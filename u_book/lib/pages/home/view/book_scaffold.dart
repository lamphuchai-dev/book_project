import 'package:flutter/material.dart';

class BookScaffold extends Scaffold {
  BookScaffold({
    Key? key,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    Widget? drawer,
    Widget? endDrawer,
    Widget? bottomNavigationBar,
    Widget? bottomSheet,
    Color? backgroundColor,
    bool? resizeToAvoidBottomPadding,
    bool primary = true,
  }) : super(
          key: key,
          appBar: appBar,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: body,
          ),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
          primary: primary,
        );
}
