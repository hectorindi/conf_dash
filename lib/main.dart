import 'package:admin/core/constants/color_constants.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Dashboard - Admin Panel v0.1',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          elevation: 10,
        ),
        scaffoldBackgroundColor: bgColor,
        primaryColor: greenColor,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        colorScheme: ColorScheme.dark(
          background: bgColor,
          surface: bgColor,
        ),
      ),
      home: Container(
        color: bgColor,
        child: Login(title: "Welcome to the Admin & Dashboard Panel"),
      ),
    );
  }
}