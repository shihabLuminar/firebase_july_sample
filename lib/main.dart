import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_july_sample/controller/home_screen_controller.dart';
import 'package:firebase_july_sample/controller/login_screen_controller.dart';
import 'package:firebase_july_sample/controller/registration_screen_controller.dart';
import 'package:firebase_july_sample/firebase_options.dart';
import 'package:firebase_july_sample/views/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => RegistrationScreenController(),
      ),
      ChangeNotifierProvider(
        create: (context) => LoginScreenController(),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeScreenController(),
      )
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
