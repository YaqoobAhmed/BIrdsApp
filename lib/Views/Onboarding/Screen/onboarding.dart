import 'package:firebase/Views/Onboarding/Widget/onboard_container.dart';
import 'package:firebase/colors.dart';
import 'package:firebase/navBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User currentUser = FirebaseAuth.instance.currentUser!;

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            User? currentUser = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context, currentUser),
                buildMenuItems(context),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget buildHeader(BuildContext context, User? user) => Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 1,
      color: Colors.blue,
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user?.displayName ?? 'No Name',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            user?.email ?? '',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
Widget buildMenuItems(BuildContext context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(initialTabIndex: 0),
                  ),
                );
              },
              leading: Icon(
                Icons.shopping_bag,
              ),
              title: Text("Buy"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.sell),
              title: Text("Sell"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.camera_alt),
              title: Text("Scan"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.store),
              title: Text("Mart"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.article),
              title: Text("Articles"),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: blueColor,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.sell),
              title: Text("My Ads"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.store),
              title: Text("My Items"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.article),
              title: Text("My Articles"),
            ),
          ],
        ),
      ),
    );

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavigationDrawer(),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/onboarding.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15, top: 8),
                  //   child: Align(
                  //     alignment: Alignment.topLeft,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => ProfileScreen(),
                  //           ),
                  //         );
                  //       },
                  //       icon: Icon(
                  //         Icons.settings,
                  //         color: whiteColor,
                  //         size: 30,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OnboardContainer(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavBar(initialTabIndex: 0),
                                ),
                              ),
                              icon: Icon(
                                Icons.shopping_bag,
                                color: whiteColor,
                                size: 42.5,
                              ),
                              text: 'Buy',
                            ),
                            OnboardContainer(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavBar(initialTabIndex: 1),
                                ),
                              ),
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
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavBar(initialTabIndex: 2),
                                ),
                              ),
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
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavBar(initialTabIndex: 3),
                                ),
                              ),
                              icon: Icon(
                                Icons.store,
                                color: whiteColor,
                                size: 42.5,
                              ),
                              text: 'Food Mart',
                            ),
                            OnboardContainer(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavBar(initialTabIndex: 4),
                                ),
                              ),
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
            AppBar(
              leading: null,
              backgroundColor: Colors
                  .transparent, // Set app bar background color to transparent
              elevation: 0, // Remove app bar elevation
            ),
          ],
        ),
      ),
    );
  }
}
