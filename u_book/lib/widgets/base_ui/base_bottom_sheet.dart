import 'package:flutter/material.dart';

class BaseBottomSheetUi extends StatelessWidget {
  const BaseBottomSheetUi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 45,
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: const ShapeDecoration(
                    shape: StadiumBorder(), color: Colors.grey),
                height: 6,
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
