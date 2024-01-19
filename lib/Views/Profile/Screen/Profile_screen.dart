import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: blueColor,
          title: Text(
            "Settings",
            style: TextStyle(color: whiteColor),
          ),
          centerTitle: true,
        ),
        body: Container(
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
                              bottomRight: Radius.elliptical(400, 100))),
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
                  "Hassan Mirza",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "hassanmirza@gmail.com",
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "03062694259",
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
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                    InkWell(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ));
                      },
                      child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Signout",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
        ));
  }
}
