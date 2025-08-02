import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:movie_people_app/presentationLayer/screens/splash_screen.dart';
import 'dataLayer/cubit/app_cubit.dart';
import 'core/utils/constansts.dart';
import 'core/utils/injection.dart' as di;
import 'core/utils/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => di.sl<AppBloc>(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
