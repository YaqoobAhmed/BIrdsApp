import 'package:firebase/Views/Foodmart/Screen/foodmart_screen.dart';
import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/Views/Profile/Screen/Profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //to fatch data
  // QuerySnapshot snapshot =
  //     await FirebaseFirestore.instance.collection("user").get();
  // for (var doc in snapshot.docs) {
  //   print(doc.data().toString());
  // }

  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map<String, dynamic> newuserdata = {
  //   "name": "Yaqoob",
  //   "mail": "yaqoob@gmail.com"
  // };
  // await _firestore.collection("user").add(newuserdata);
  //.doc("").update()
  //.doc("").delete

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodMartScreen(),
      // home: (FirebaseAuth.instance.currentUser != null)
      //     ? OnboardingScreen()
      //     : LoginView(),
    );
  }
}
