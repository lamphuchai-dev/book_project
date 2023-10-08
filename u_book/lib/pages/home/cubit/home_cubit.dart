import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/services/storage_service.dart';
import 'package:u_book/utils/logger.dart';

part 'home_state.dart';

final netTruyenMap = {
  "name": "Net Truyện",
  "author": "uBook",
  "version": 1,
  "source": "https://www.nettruyenus.com",
  "regexp": "",
  "description": "Đọc truyện trên trang Net Truyện",
  "locale": "vi_VN",
  "language": "javascript",
  "type": "comic",
  "script":
      "https://raw.githubusercontent.com/lamphuchai-dev/book_project/main/ext-book/net_truyen.js",
  "tabsHome": [
    {"title": "Mới cập nhật", "url": "/tim-truyen"},
    {"title": "Truyện mới", "url": "/tim-truyen?status=-1&sort=15"},
    {"title": "Top all", "url": "/tim-truyen?status=-1&sort=10"},
    {"title": "Top tháng", "url": "/tim-truyen?status=-1&sort=11"},
    {"title": "Top tuần", "url": "/tim-truyen?status=-1&sort=12"},
    {"title": "Top ngày", "url": "/tim-truyen?status=-1&sort=13"},
    {"title": "Theo dõi", "url": "/tim-truyen?status=-1&sort=20"},
    {"title": "Bình luận", "url": "/tim-truyen?status=-1&sort=25"}
  ],
  "enableSearch": true,
  "enableGenre": true
};

final sayTruyenMap = {
  "name": "Say  Truyện",
  "author": "vBook",
  "version": 1,
  "source": "https://saytruyenmoi.com",
  "regexp": "",
  "description": "Đọc truyện trên trang Say Truyện",
  "locale": "vi_VN",
  "language": "javascript",
  "type": "comic",
  "script":
      "https://raw.githubusercontent.com/lamphuchai-dev/ext-book/main/list-ext/net-truyen/src/net-truyen-ext.js",
  "tabsHome": [
    {"title": "Truyện mới cập nhật", "url": "/"},
    {"title": "Manhwa", "url": "/genre/manhwa"},
    {"title": "Manga", "url": "/genre/manga"},
    {"title": "Romance", "url": "/genre/romance"},
  ],
  "enableSearch": true,
  "enableGenre": true,
};

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ExtensionsManager extensionsManager})
      : _extensionsManager = extensionsManager,
        super(HomeState(
            extStatus: ExtensionStatus.loaded,
            extension: extensionsManager.runTimePrimary!.extension));
  final _logger = Logger("HomeCubit");

  final ExtensionsManager _extensionsManager;
  late ExtensionRunTime _runTime;

  String get nameExt => "fe";

  void onInit() async {
    _runTime = _extensionsManager.runTimePrimary!;
  }

  Future<List<Book>> onGetListBook(String url, int page) async {
    try {
      return await _runTime.getListBook(url: url, page: page);
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
    }
    return [];
  }

  Future<List<Book>> onSearchBook(String keyWord, int page) async {
    try {
      return await _runTime.search(keyWord, page);
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
    }
    return [];
  }

  void onChangeExtensions(Extension extension) async {
    emit(state.copyWith(extension: extension, extStatus: ExtensionStatus.init));
    final newRunTime = await _extensionsManager.setRunTimePrimary(extension);
    if (newRunTime == null) {
      emit(state.copyWith(extStatus: ExtensionStatus.error));
    }
    _runTime = newRunTime!;
    emit(state.copyWith(extStatus: ExtensionStatus.loaded));
  }
}
