import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/widgets/widgets.dart';

class SelectExtensionBottomSheet extends StatelessWidget {
  const SelectExtensionBottomSheet(
      {super.key, required this.extensions, required this.onSelected});
  final List<Extension> extensions;
  final ValueChanged<Extension> onSelected;

  @override
  Widget build(BuildContext context) {
    final width = context.width / 2 - 24;
    return SizedBox(
      width: double.infinity,
      child: BaseBottomSheetUi(
        child: SingleChildScrollView(
          child: Column(children: [
            Gaps.hGap16,
            Wrap(
                children: extensions
                    .map((e) => _extCard(e, width, context))
                    .toList()),
            Gaps.hGap24
          ]),
        ),
      ),
    );
  }

  Widget _extCard(Extension extension, double width, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected.call(extension);
        Navigator.pop(context);
      },
      child: Container(
        height: 60,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: Dimens.cardBookBorderRadius),
        child: Text(extension.name),
      ),
    );
  }
}
