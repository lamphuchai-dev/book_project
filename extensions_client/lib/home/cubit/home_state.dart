// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({required this.result, required this.log});
  final String result;
  final dynamic log;

  @override
  List<Object?> get props => [result, log];

  HomeState copyWith({
    String? result,
    dynamic log,
  }) {
    return HomeState(
      result: result ?? this.result,
      log: log ?? this.log,
    );
  }
}
