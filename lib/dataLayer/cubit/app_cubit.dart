import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:movie_people_app/dataLayer/cubit/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
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
      (dataList) {
        if (dataList.isEmpty) {
          hasMoreData = false;
        } else {
          allPerson.addAll(dataList);
          page++;
        }

        isLoadingMore = false;

        if (isPagination) {
          emit(GetPersonPaginationSuccess());
        } else {
          emit(GetPersonSuccess());
        }
      },
    );
  }

  Future<void> saveImageFromUrl(String imageUrl, String fileName) async {
    emit(SaveImageLoading());

    try {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        emit(SaveImageError(error: 'Permission denied'));
        return;
      }

      final response = await Dio().get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Uint8List imageBytes = Uint8List.fromList(response.data!);

        final result = await SaverGallery.saveImage(
          imageBytes,
          fileName: fileName,
          skipIfExists: false, // required in saver_gallery >=1.0.1
        );
        emit(SaveImageSuccess());
      } else {
        emit(SaveImageError(error: 'Download failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SaveImageError(error: e.toString()));
    }
  }
}
