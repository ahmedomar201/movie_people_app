import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/constansts.dart';
import '../local/cache_helper.dart';
import '../models/person_model.dart';
import '../remote/dio_helper.dart';

abstract class Repository {
  Future<Either<String, List<PersonModel>>> getPerson(int page);
}

class RepoImplementation extends Repository {
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  RepoImplementation({required this.cacheHelper, required this.dioHelper});

  @override
  Future<Either<String, List<PersonModel>>> getPerson(int page) async {
    return basicErrorHandling<List<PersonModel>>(
      onSuccess: () async {
        var response = await dioHelper.get(
          url: "3/person/popular?page=$page&api_key=$apiKey",
        );
        debugPrint('getPerson response =====> ${response.data}');

        await cacheHelper.put('people_page_$page', response.data);

        final List results = response.data['results'];
        final people = results
            .map((json) => PersonModel.fromJson(json))
            .toList();

        return people;
      },
      onServerError: (exception) async {
        debugPrint('Server error: ${exception.message}');
        final cachedData = await cacheHelper.get('people_page_$page');
        if (cachedData != null) {
          final List results = cachedData['results'];
          final people = results
              .map((json) => PersonModel.fromJson(json))
              .toList();
          debugPrint('Loaded from cache for page $page');
          return Right(people);
        }
        return Left(exception.message);
      },
    );
  }
}

Future<Either<String, T>> basicErrorHandling<T>({
  required Future<T> Function() onSuccess,
  Future<Either<String, T>> Function(ServerException exception)? onServerError,
  Future<Either<String, T>> Function(CacheException exception)? onCacheError,
  Future<Either<String, T>> Function(dynamic exception)? onOtherError,
}) async {
  try {
    final f = await onSuccess();
    return Right(f);
  } on ServerException catch (e, s) {
    debugPrint(s.toString());
    if (onServerError != null) {
      final f = await onServerError(e);
      return f;
    }
    return const Left('Server Error');
  } on CacheException catch (e) {
    debugPrint(e.toString());
    if (onCacheError != null) {
      final f = await onCacheError(e);
      return f;
    }
    return const Left('Cache Error');
  } catch (e, s) {
    debugPrint(s.toString());
    if (onOtherError != null) {
      final f = await onOtherError(e);
      return f;
    }
    return Left(e.toString());
  }
}
