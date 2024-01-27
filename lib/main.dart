import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null ? const OnboardingScreen() : const LoginView(),
    );
  }
}

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PersistentTabView(
//         context,
//         screens: screens(),
//         items: navBarItems(),
//         navBarStyle: NavBarStyle.style13,
//       ),
//     );
//   }
// }

// List<Widget> screens() {
//   return [
//     BuyScreen(),
//     SellScreen(),
//     FoodMartScreen(),
//     BuyScreen(),
//     SellScreen(),
//   ];
// }

// List<PersistentBottomNavBarItem> navBarItems() {
//   return [
//     PersistentBottomNavBarItem(
//         icon: Icon(Icons.shopping_bag),
//         activeColorPrimary: blueColor,
//         title: "Buy",
//         inactiveColorPrimary: Colors.white),
//     PersistentBottomNavBarItem(
//         icon: Icon(Icons.sell),
//         activeColorPrimary: blueColor,
//         title: "Sell",
//         inactiveColorPrimary: Colors.white),
//     PersistentBottomNavBarItem(
//         icon: Icon(Icons.sell),
//         activeColorPrimary: blueColor,
//         title: "Food",
//         inactiveColorPrimary: Colors.white),
//     PersistentBottomNavBarItem(
//         icon: Icon(Icons.shopping_bag),
//         activeColorPrimary: blueColor,
//         title: "Buy",
//         inactiveColorPrimary: Colors.white),
//     PersistentBottomNavBarItem(
//         icon: Icon(Icons.sell),
//         activeColorPrimary: blueColor,
//         title: "Sell",
//         inactiveColorPrimary: Colors.white),
//   ];
// }
