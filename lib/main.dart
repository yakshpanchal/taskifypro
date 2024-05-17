import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskifypro/firebase_options.dart';
import 'package:taskifypro/src/Authentication/presentation/Loginpage.dart';
import 'package:taskifypro/src/Home/home.dart';

void main() async {
  //
  print('firebase initializing...');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('firebase initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      themeMode: ThemeMode.system,
      // theme: TAppTheme.lightTheme,
      // darkTheme: TAppTheme.darkTheme,
      home: user == null ? LoginScreen() : HomeScreen(),
    );
  }
}
