// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_cubit.dart';

class SplashState extends Equatable {
  const SplashState({required this.statusType});
  final StatusType statusType;
  @override
  List<Object> get props => [statusType];

  SplashState copyWith({
    StatusType? statusType,
  }) {
    return SplashState(
      statusType: statusType ?? this.statusType,
    );
  }
}
