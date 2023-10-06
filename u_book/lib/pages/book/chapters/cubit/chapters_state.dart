// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chapters_cubit.dart';

class ChaptersState extends Equatable {
  const ChaptersState({required this.book});
  final Book book;
  @override
  List<Object> get props => [book];

  ChaptersState copyWith({
    Book? book,
  }) {
    return ChaptersState(
      book: book ?? this.book,
    );
  }
}
