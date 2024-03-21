import 'package:firebase/Views/My_Ads/Screens/my_ads.dart';
import 'package:firebase/Views/My_Ads/Screens/my_articles.dart';
import 'package:firebase/Views/My_Ads/Screens/my_items.dart';
import 'package:firebase/Views/Profile/Screen/Profile_screen.dart';
import 'package:firebase/Views/Profile/widget/signout_dialog.dart';
import 'package:firebase/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 1,
              color: blueColor,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                bottom: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: 42,
                    backgroundImage: AssetImage("assets/images/logoMain.png"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentUser.email ?? 'Not Available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  ),
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAds(
                          currentUserUid: currentUser.uid,
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.sell),
                  title: Text("My Ads"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyItems(
                          currentUserUid: currentUser.uid,
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.store),
                  title: Text("My Items"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyArticles(
                          currentUserUid: currentUser.uid,
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.article),
                  title: Text("My Articles"),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: blueColor,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
                ListTile(
                  onTap: () {
                    showSignoutDialog(context);
                  },
                  leading: Icon(Icons.logout),
                  title: Text("Signout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
