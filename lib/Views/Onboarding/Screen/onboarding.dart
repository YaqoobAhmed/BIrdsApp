import 'package:firebase/Views/Login/login.dart';
import 'package:firebase/Views/Onboarding/Widget/onboard_container.dart';
import 'package:firebase/Views/Profile/Screen/Profile_screen.dart';
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
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(context),
        buildMenuItems(context),
      ],
    ));
  }
}

Widget buildHeader(BuildContext context) => GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          )),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 1,
        color: blueColor,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 38,
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: blueColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              currentUser.email ?? 'Not Available',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );

Widget buildMenuItems(BuildContext context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  )),
              leading: Icon(Icons.person),
              title: Text("Profile"),
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
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ),
                  (route) => false,
                );
              },
              leading: Icon(Icons.logout),
              title: Text("Signout"),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              color: blueColor,
            ),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(initialTabIndex: 1),
                  ),
                );
              },
              leading: Icon(Icons.sell),
              title: Text("Sell"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(initialTabIndex: 2),
                  ),
                );
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Scan"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(initialTabIndex: 3),
                  ),
                );
              },
              leading: Icon(Icons.store),
              title: Text("Mart"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(initialTabIndex: 4),
                  ),
                );
              },
              leading: Icon(Icons.article),
              title: Text("Articles"),
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
                  // Your content here
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
