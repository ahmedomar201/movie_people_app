import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/cubit/app_cubit.dart';
import 'package:movie_people_app/dataLayer/cubit/app_state.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';

class FullImageScreen extends StatelessWidget {
  final String imageUrl;
  final PersonModel person;

  const FullImageScreen({
    super.key,
    required this.imageUrl,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Stack(
              children: [
                InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => NewWidget(),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      // cubit.saveNetworkImage(imageUrl);
                    },
                    icon: const Icon(Icons.download),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Image not available',
      style: TextStyle(color: Colors.white),
    );
  }
}
