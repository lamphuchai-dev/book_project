import 'package:book/core/extension_runtime.dart';
import 'package:book/models/extension.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

final netTruyenMap = {
  "name": "Net Truyện",
  "author": "vBook",
  "version": 1,
  "source": "https://www.nettruyenus.com",
  "regexp":
      r'(www.)?(nhattruyen|nettruyen|nettruyentop|nettruyenvip|nettruyenpro|nettruyengo|nettruyenmoi|nettruyenone|nettruyenco|nettruyenme|nettruyenin|nettruyenon|nettruyentv|nettruyenmin|nettruyenking|nettruyenvi|nettruyenplus|nettruyenmax|nettruyenus).(com|vn)/truyen-tranh/[^/]+/?$',
  "description": "Đọc truyện trên trang Net Truyện",
  "locale": "vi_VN",
  "language": "javascript",
  "type": "comic",
  "script":
      "https://raw.githubusercontent.com/lamphuchai-dev/ext-book/main/list-ext/net-truyen/src/net-truyen-ext.js"
};

Future<void> setupLocator() async {
  final ExtensionRuntime runtime = ExtensionRuntime();
  runtime.initRuntime(Extension.fromMap(netTruyenMap));
  getIt.registerSingleton(runtime);
}
