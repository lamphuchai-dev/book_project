import 'package:isar/isar.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';

class DatabaseService {
  final _logger = Logger("DatabaseService");
  late final Isar database;
  late String _path;

  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    database = await Isar.open(
      [ExtensionSchema, BookSchema],
      directory: _path,
    );
  }

  Future<dynamic> addExtension(Extension extension) async {
    return database.writeTxn(() => database.extensions.put(extension));
  }

  void changeIsPrimaryExtension(List<Extension> extensions) {
    database.writeTxn(() => database.extensions.putAll(extensions));
  }

  Future<dynamic> insertExtensions(List<Extension> extensions) async {
    return await database
        .writeTxn(() => database.extensions.putAll(extensions));
  }

  Future<List<Extension>> getExtensions() {
    return database.extensions.where().findAll();
  }

  Future<int?> onInsertBook(Book book) async {
    return database.writeTxn(() => database.books
        .put(book.copyWith(updateAt: DateTime.now(), bookmark: true)));
  }

  Future<bool> onDeleteBook(int id) async {
    return database.writeTxn(() => database.books.delete(id));
  }

  Future<List<Book>> getBooks() {
    return database.books.where().sortByUpdateAtDesc().findAll();
  }

  Future<dynamic> updateBook(Book book) {
    return database.writeTxn(() => database.books.put(book));
  }

  Future<bool> deleteExtension(int id) {
    return database.writeTxn(() => database.books.delete(id));
  }

  Future<Book?> getBookByUrl(String bookUrl) =>
      database.books.filter().bookUrlMatches(bookUrl).findFirst();

  Stream<void> get bookStream => database.books.watchLazy();

  Stream<void> get extensionsChange => database.extensions.watchLazy();
}
