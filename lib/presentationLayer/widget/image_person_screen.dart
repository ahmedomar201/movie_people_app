import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_people_app/dataLayer/cubit/app_cubit.dart';
import 'package:movie_people_app/dataLayer/cubit/app_state.dart';
import 'package:movie_people_app/dataLayer/networks/models/person_model.dart';
import 'package:movie_people_app/presentationLayer/helper/snakbar_error.dart';

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
    return BlocConsumer<AppBloc, AppState>(
      listener: (BuildContext context, AppState state) {
        if (state is SaveImageSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved successfully!')),
          );
        } else if (state is SaveImageError) {
          showCustomErrorSnackbar(
            context: context,
            message: 'Failed to save image: ${state.error}',
          );
        }
      },
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
                    errorBuilder: (context, error, stackTrace) => Text(
                      'Image not available',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      cubit.saveImageFromUrl(imageUrl, person.profilePath ?? '');
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
