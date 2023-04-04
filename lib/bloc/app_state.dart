part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({required AppForm viewModel, String? result}) =
      _AppState;

  factory AppState.initial() => AppState(
        viewModel: AppForm(),
        result: '',
      );
}
