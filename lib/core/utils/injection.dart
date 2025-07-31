import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:movie_people_app/dataLayer/networks/local/cache_helper.dart';
import 'package:movie_people_app/dataLayer/networks/remote/dio_helper.dart';
import 'package:movie_people_app/dataLayer/networks/repository/repository.dart';
import 'package:movie_people_app/dataLayer/cubit/app_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<DioHelper>(() => DioImpl());
  sl.registerLazySingleton<CacheHelper>(() => CacheImpl(sl()));

  sl.registerLazySingleton<Repository>(
    () => RepoImplementation(dioHelper: sl(), cacheHelper: sl()),
  );

  sl.registerFactory(() => AppBloc(repository: sl()));
}
