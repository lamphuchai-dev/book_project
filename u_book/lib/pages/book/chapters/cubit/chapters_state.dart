// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chapters_cubit.dart';

class ChaptersState extends Equatable {
  const ChaptersState({required this.chapters, required this.statusType});
  final List<Chapter> chapters;
  final StatusType statusType;
  @override
  List<Object> get props => [chapters, statusType];

  ChaptersState copyWith({
    List<Chapter>? chapters,
    StatusType? statusType,
  }) {
    return ChaptersState(
      chapters: chapters ?? this.chapters,
      statusType: statusType ?? this.statusType,
    );
  }
}
