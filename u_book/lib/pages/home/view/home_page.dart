import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/context_extension.dart';
import 'package:u_book/app/routes/routes_name.dart';
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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        Widget body = const SizedBox();
        Widget title = const SizedBox();
        bool enableSearch = false;
        if (state is LoadingExtensionState || state is HomeStateInitial) {
          body = const LoadingWidget();
        } else if (state is ExtensionNoInstallState) {
          body = SizedBox(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.extension_off_rounded,
                    size: 100,
                  ),
                  Gaps.hGap16,
                  const Text("Chưa có tiện ích nào được cài đặt"),
                  Gaps.hGap16,
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.installExt);
                      },
                      child: const Text("Cài đặt tiện tích"))
                ]),
          );
          title = const Text("Tiện ích");
        } else if (state is LoadedExtensionState) {
          body = _extReady(state.extension);
          enableSearch = true;
          title = GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: context.colorScheme.background,
                builder: (context) => SelectExtensionBottomSheet(
                  extensions: getIt<ExtensionsManager>().getExtensions,
                  exceptionPrimary: state.extension,
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
        }

        return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: title,
              actions: enableSearch
                  ? [
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: SearchBookDelegate(
                                  onSearchBook: _homeCubit.onSearchBook,
                                ));
                          },
                          icon: const Icon(Icons.search_rounded))
                    ]
                  : [],
            ),
            body: body);
      },
    );
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
                return _homeCubit.onGetListBook(tabHome.url!, page);
              },
              onTap: (book) {
                Navigator.pushNamed(context, RoutesName.detailBook,
                    arguments: book);
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
