import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/extensions/context_extension.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/pages/book/read_book/read_book.dart';
import 'package:u_book/widgets/widgets.dart';
import '../cubit/chapters_cubit.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  late ChaptersCubit _chaptersCubit;
  late Book _book;
  @override
  void initState() {
    _chaptersCubit = context.read<ChaptersCubit>();
    _book = _chaptersCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_book.name),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
        child: BlocBuilder<ChaptersCubit, ChaptersState>(
          builder: (context, state) {
            if (state.statusType == StatusType.loading) {
              return const LoadingWidget();
            }
            final chapters = state.chapters;
            return Column(
              children: [
                Divider(
                  height: 1,
                  color: colorScheme.surface,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    "${chapters.length} chương",
                    style: textTheme.bodyMedium,
                  ),
                  trailing: PopupMenuButton(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(child: Text("Mới nhất")),
                        const PopupMenuItem(child: Text("Củ nhất"))
                      ];
                    },
                    child: const SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Text("Mới nhất"), Icon(Icons.expand_more)],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.surface,
                ),
                Expanded(
                    child: ListChaptersWidget(
                  chapters: chapters,
                  onTapChapter: (chapter) {
                    Navigator.pushNamed(context, RoutesName.readBook,
                        arguments: ReadBookArgs(
                            book: _book,
                            chapters: chapters,
                            readChapter: chapter.index,
                            fromBookmarks: false,
                            loadChapters: false));
                  },
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
