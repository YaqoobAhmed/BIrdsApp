import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Drawer/drawer.dart';
import 'package:firebase/Views/Onboarding/Widget/onboard_container.dart';
import 'package:firebase/colors.dart';
import 'package:firebase/provider/phone_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final User currentUser = FirebaseAuth.instance.currentUser!;

  late Stream<DocumentSnapshot> userDataStream;

  late String contact;

  @override
  void initState() {
    super.initState();
    userDataStream = FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser.email)
        .snapshots();

    // Listen to the userDataStream and update the contact information
    userDataStream.listen((snapshot) {
      setState(() {
        contact = snapshot['phoneNumber'];
      });
      // Update the contact information in the PhoneProvider
      Provider.of<PhoneProvider>(context, listen: false)
          .setPhoneNumber(contact);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Avian Tech Emporium"),
        ),
        drawer: CustomNavigationDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/onboarding.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OnboardContainer(
                          initialTabIndex: 0,
                          icon: Icon(
                            Icons.shopping_bag,
                            color: whiteColor,
                            size: 42.5,
                          ),
                          text: 'Buy',
                        ),
                        OnboardContainer(
                          initialTabIndex: 1,
                          icon: Icon(
                            Icons.sell,
                            color: whiteColor,
                            size: 42.5,
                          ),
                          text: 'Sell',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OnboardContainer(
                          initialTabIndex: 2,
                          icon: Icon(
                            Icons.camera_alt,
                            color: whiteColor,
                            size: 42.5,
                          ),
                          text: 'Scan',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OnboardContainer(
                          initialTabIndex: 3,
                          icon: Icon(
                            Icons.store,
                            color: whiteColor,
                            size: 42.5,
                          ),
                          text: 'Food Mart',
                        ),
                        OnboardContainer(
                          initialTabIndex: 4,
                          icon: Icon(
                            Icons.article,
                            color: whiteColor,
                            size: 42.5,
                          ),
                          text: 'Articles',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
