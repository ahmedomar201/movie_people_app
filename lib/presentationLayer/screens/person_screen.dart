import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';
import '../../dataLayer/cubit/app_cubit.dart';
import '../../dataLayer/cubit/app_state.dart';
import '../helper/snakbar_error.dart';
import '../widget/person_card.dart';

class PersonListScreen extends StatelessWidget {
  const PersonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Popular People',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state is GetPersonError || state is GetPersonPaginationError) {
            showCustomErrorSnackbar(
              context: context,
              message: 'Failed to load people data. Please try again.',
            );
          }

          // if (cubit.person == null) {
          //   showCustomErrorSnackbar(
          //     context: context,
          //     message: 'please check your internet connection.',
          //   );
          // }
        },
        builder: (context, state) {
          if (state is GetPersonLoading && cubit.allPerson.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                if (scrollNotification.metrics.pixels >=
                        scrollNotification.metrics.maxScrollExtent * 0.8 &&
                    !cubit.isLoadingMore &&
                    cubit.hasMoreData) {
                  cubit.getperson(isPagination: true);
                }
              }
              return false;
            },
            child: ListView.builder(
              itemCount: cubit.allPerson.length + (cubit.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < cubit.allPerson.length) {
                  final PersonModel person = cubit.allPerson[index];
                  return PersonCard(
                    name: person.name ?? '',
                    department: person.knownForDepartment ?? '',
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${person.profilePath}',
                    person: person,
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
