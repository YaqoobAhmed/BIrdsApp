import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/colors.dart';
import 'package:firebase/provider/phone_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PhoneProvider()),
        ],
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                    centerTitle: true,
                    color: blueColor,
                    // titleTextStyle: GoogleFonts.carterOne(),
                    titleTextStyle: TextStyle(
                      fontFamily: "CarterOne",
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                    foregroundColor: whiteColor)),
            debugShowCheckedModeBanner: false,
            home: user != null ? OnboardingScreen() : LoginView(),
          );
        });
  }
}
