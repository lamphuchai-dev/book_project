import 'package:isar/isar.dart';
import 'package:u_book/data/models/book_model.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';

class DatabaseService {
  final _logger = Logger("DatabaseService");
  late final Isar database;
  late String _path;

  void ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    database = await Isar.open(
      [ExtensionSchema],
      directory: _path,
    );
  }

  void tmp() {
    database.writeTxn(
        () => database.bookModels.put(BookModel(name: "test", bookUrl: "ulr")));
  }

  dynamic test() async {
    return database.extensions.where().findAll();
  }

  void addExtension(Extension extension) {
    database.writeTxn(() => database.extensions.put(extension));
  }

  void changeIsPrimaryExtension(List<Extension> extensions) {
    database.writeTxn(() => database.extensions.putAll(extensions));
  }

  Future<dynamic> insertExtensions(List<Extension> extensions) async {
    return await database
        .writeTxn(() => database.extensions.putAll(extensions));
  }

  Future<List<Extension>> findAllExtensions() {
    return database.extensions.where().findAll();
  }
}
