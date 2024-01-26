import 'package:firebase/Views/Foodmart/Tabs/Buy/food_buy.dart';
import 'package:firebase/Views/Foodmart/Tabs/Sell/food_sell.dart';

import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class FoodMartScreen extends StatelessWidget {
  const FoodMartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: whiteColor,
                )),
            title: Text(
              "Food Mart",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: blueColor,
            bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.shopping_bag,
                      color: whiteColor,
                    ),
                    child: Text(
                      "Buy",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.sell,
                      color: whiteColor,
                    ),
                    child: Text(
                      "Sell",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [FoodBuyScreen(), FoodSellScreen()]),
        ));
  }
}
