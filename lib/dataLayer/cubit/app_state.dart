abstract class AppState {}

class Empty extends AppState {}

class GetPersonLoading extends AppState {}

class GetPersonSuccess extends AppState {}

class GetPersonError extends AppState {
  final String error;
  GetPersonError({required this.error});
}

class GetPersonPaginationSuccess extends AppState {}

class GetPersonPaginationLoading extends AppState {}

class GetPersonPaginationError extends AppState {
  final String error;
  GetPersonPaginationError({required this.error});
}

class SaveImageSuccess extends AppState {}

class SaveImageError extends AppState {
  final String error;
  SaveImageError({required this.error});
}

class SaveImageLoading extends AppState {}
