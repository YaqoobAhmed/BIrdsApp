import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class BuyBanner extends StatelessWidget {
  const BuyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: blueColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.5, horizontal: 20),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hey, Yaqoob",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const Positioned(
          //     top: 100, left: 20, right: 20, child: GrocerySearchbar()),
        ]),
      ],
    );
  }
}
