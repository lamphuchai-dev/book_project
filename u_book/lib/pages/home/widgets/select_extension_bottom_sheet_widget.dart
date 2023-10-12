import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/widgets/widgets.dart';

class SelectExtensionBottomSheet extends StatelessWidget {
  const SelectExtensionBottomSheet(
      {super.key,
      required this.extensions,
      required this.onSelected,
      required this.exceptionPrimary});
  final List<Extension> extensions;
  final ValueChanged<Extension> onSelected;
  final Extension exceptionPrimary;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return SizedBox(
      width: double.infinity,
      child: BaseBottomSheetUi(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Text("Tiện ích mở rộng", style: textTheme.titleMedium),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RoutesName.installExt);
                      },
                      icon: const Icon(Icons.more_vert)),
                ))
              ],
            ),
            SingleChildScrollView(
              child: Column(children: [
                Gaps.hGap16,
                Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: extensions
                        .map((ext) => ExtensionCard(
                              extension: ext,
                              isPrimary: ext.id == exceptionPrimary.id,
                              onTap: () {
                                if (!ext.isPrimary) {
                                  onSelected.call(ext);
                                }
                                // onSelected.call(ext);

                                Navigator.pop(context);
                              },
                            ))
                        .toList()),
                Gaps.hGap24
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtensionCard extends StatelessWidget {
  const ExtensionCard(
      {super.key,
      required this.extension,
      required this.onTap,
      this.isPrimary = false});
  final Extension extension;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final width = context.width / 2 - 16;
    final uri = Uri.parse(extension.source);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            color: isPrimary
                ? colorScheme.primary.withOpacity(0.7)
                : colorScheme.surface,
            borderRadius: Dimens.cardBookBorderRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              extension.name,
              style: textTheme.titleMedium,
            ),
            Text(
              uri.host,
              style:
                  textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
