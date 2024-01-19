import 'package:firebase/Views/Article/Screen_article/article_screen.dart';
import 'package:firebase/Views/Onboarding/Widget/onboard_container.dart';
import 'package:firebase/Views/buy/Screen/buy.dart';
import 'package:firebase/Views/sell/Screen/Sell.dart';
import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/onboarding.jpg"),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              OnboardContainer(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuyScreen(),
                    )),
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
                      builder: (context) => SellScreen(),
                    )),
                icon: Icon(
                  Icons.sell,
                  color: whiteColor,
                  size: 42.5,
                ),
                text: 'Sell',
              ),
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnboardContainer(
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              OnboardContainer(
                // onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => BuyScreen(),
                //     )),
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
                      builder: (context) => ArticleScreen(),
                    )),
                icon: Icon(
                  Icons.article,
                  color: whiteColor,
                  size: 42.5,
                ),
                text: 'Articles',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
