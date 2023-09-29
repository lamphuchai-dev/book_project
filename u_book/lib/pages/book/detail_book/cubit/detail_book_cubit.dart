import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/data/models/book.dart';

part 'detail_book_state.dart';

class DetailBookCubit extends Cubit<DetailBookState> {
  DetailBookCubit({required this.book}) : super(DetailBookInitial());
  final Book book;

  void onInit() {}
}
