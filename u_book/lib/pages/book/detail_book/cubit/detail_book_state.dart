// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_book_cubit.dart';

class DetailBookState extends Equatable {
  const DetailBookState({required this.book, required this.statusType});
  final Book book;
  final StatusType statusType;
  @override
  List<Object> get props => [book, statusType];

  DetailBookState copyWith({
    Book? book,
    StatusType? statusType,
  }) {
    return DetailBookState(
      book: book ?? this.book,
      statusType: statusType ?? this.statusType,
    );
  }
}
