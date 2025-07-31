import 'package:movie_people_app/dataLayer/cubit/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';
import '../../core/utils/constansts.dart';
import '../networks/repository/repository.dart';

AppBloc get cubit => AppBloc.get(navigatorKey.currentContext!);

class AppBloc extends Cubit<AppState> {
  final Repository repo;

  AppBloc({required Repository repository})
    : repo = repository,
      super(Empty()) {
    getperson();
  }

  static AppBloc get(context) => BlocProvider.of(context);

  PersonModel? person;
  int page = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List<PersonModel> allPerson = [];

  void getperson({bool isPagination = false, context}) async {
    if (isPagination) {
      if (isLoadingMore || !hasMoreData) return;
      isLoadingMore = true;
      emit(GetPersonPaginationLoading());
    } else {
      emit(GetPersonLoading());
      allPerson.clear();
      page = 1;
      hasMoreData = true;
    }

    final result = await repo.getPerson(page);

    result.fold(
      (failure) {
        isLoadingMore = false;
        if (isPagination) {
          emit(GetPersonPaginationError(error: failure));
        } else {
          emit(GetPersonError(error: failure));
        }
      },
      (data) {
        allPerson.add(data);
        page++;
      
        person = data;
        isLoadingMore = false;

        if (isPagination) {
          emit(GetPersonPaginationSuccess());
        } else {
          emit(GetPersonSuccess());
        }
      },
    );
  }
}
