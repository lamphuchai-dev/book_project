import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/pages/home/widgets/widgets.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/widgets/widgets.dart';
import '../cubit/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SelectExtensionBottomSheet(
                      extensions: getIt<ExtensionsManager>().extensions,
                      onSelected: (ext) {
                        _homeCubit.onChangeExtensions(ext);
                      },
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text(state.extension.name)),
                    Gaps.wGap8,
                    const Icon(
                      Icons.expand_more_rounded,
                      size: 26,
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchBookDelegate(
                        onSearchBook: _homeCubit.onSearchBook,
                      ));
                },
                icon: const Icon(Icons.search_rounded))
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return switch (state.extStatus) {
              ExtensionStatus.loaded => _extReady(state.extension),
              _ => const LoadingWidget()
            };
          },
        ));
  }

  Widget _extReady(Extension extension) {
    final tabItems = extension.tabsHome
        .map(
          (e) => Tab(
            text: e.title,
          ),
        )
        .toList();
    final tabChildren = extension.tabsHome
        .map(
          (tabHome) => KeepAliveWidget(
            child: BooksGridWidget(
              onFetchListBook: (page) {
                return _homeCubit.onGetListBook(tabHome.url, page);
              },
            ),
          ),
        )
        .toList();
    return DefaultTabController(
      length: extension.tabsHome.length,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                tabs: tabItems),
            Expanded(child: TabBarView(children: tabChildren))
          ],
        ),
      ),
    );
  }
}
