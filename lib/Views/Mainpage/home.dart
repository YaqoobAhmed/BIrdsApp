import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/colors.dart';
import 'package:firebase/firebase%20service/auth_service.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: const Center(
            child: Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuthService.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
        },
        backgroundColor: blueColor,
        child: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("user").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                userMap["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(userMap["phone"]),
                            ),
                          );
                        });
                  } else {
                    return const Text("no data");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}
