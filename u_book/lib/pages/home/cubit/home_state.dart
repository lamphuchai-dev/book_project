// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

enum ExtensionStatus { init, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({required this.extension, required this.extStatus});
  final Extension extension;
  final ExtensionStatus extStatus;

  @override
  List<Object> get props => [extension, extStatus];

  HomeState copyWith({
    Extension? extension,
    ExtensionStatus? extStatus,
  }) {
    return HomeState(
      extension: extension ?? this.extension,
      extStatus: extStatus ?? this.extStatus,
    );
  }
}
