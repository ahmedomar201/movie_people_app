import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:movie_people_app/dataLayer/cubit/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> downloadImage(String imageUrl, String fileName) async {
    emit(SaveImageLoading());

    final dir = await getExternalStorageDirectory();
    final downloadDir = Directory('${dir?.path}/Download');

    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final filePath = '${downloadDir.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    await FlutterDownloader.enqueue(
      url: imageUrl,
      savedDir: downloadDir.path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );
    emit(SaveImageSuccess());
  }
}
