import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';
import '../../dataLayer/cubit/app_cubit.dart';
import '../../dataLayer/cubit/app_state.dart';
import '../helper/snakbar_error.dart';
import '../widget/book_list_item.dart';

class PersonListScreen extends StatelessWidget {
  const PersonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AppBloc>(context);

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
              message: (state as dynamic).error,
            );
          }
        },
        builder: (context, state) {
          if (state is GetPersonLoading && cubit.allPerson.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels >=
                      scrollNotification.metrics.maxScrollExtent - 200 &&
                  !cubit.isLoadingMore &&
                  cubit.hasMoreData) {
                cubit.getperson(isPagination: true);
              }
              return false;
            },
            child: ListView.builder(
              itemCount:
                  cubit.allPerson.length + (cubit.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < cubit.allPerson.length) {
                  final PersonModel person = cubit.allPerson[index]; // explicitly type the person variable

                  return PersonListItem(
                    title: person.name ?? 'Unknown',
                    imageUrl: person.profilePath != null
                        ? 'https://image.tmdb.org/t/p/w500${person.profilePath}'
                        : null,
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
