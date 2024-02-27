import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/Views/Onboarding/Screen/onboarding.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen(),
                    ));
              },
              icon: Icon(
                Icons.arrow_back,
                color: whiteColor,
              )),
          backgroundColor: blueColor,
          title: Text(
            "Settings",
            style: TextStyle(color: whiteColor),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("user")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          opacity: 0.7,
                          image: AssetImage("assets/images/settings.jpg"),
                          fit: BoxFit.cover)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Stack(children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 1,
                              decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.elliptical(400, 100),
                                      bottomRight:
                                          Radius.elliptical(400, 100))),
                            ),
                            Positioned(
                              top: 35,
                              left: 150,
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 45,
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: blueColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 35,
                                right: 150,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: blueColor,
                                )),
                          ]),
                        ),
                        Text(
                          userData["name"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Email:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData["email"],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ]),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Contact:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData["phone"],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ]),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "NIC No:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "42101-XXXXXXX-X",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ]),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(),
                                  ),
                                  (route) =>
                                      false, // This line removes all the previous routes from the stack
                                );
                              },
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Signout",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.logout)
                                  ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error${snapshot.error}"),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
