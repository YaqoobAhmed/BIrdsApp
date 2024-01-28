import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase/Scan/Screen/scan.dart';
import 'package:firebase/Views/Article/Screen_article/article_screen.dart';
import 'package:firebase/Views/Foodmart/Screen/foodmart_screen.dart';
import 'package:firebase/Views/buy/Screen/buy.dart';
import 'package:firebase/Views/sell/Screen/Sell.dart';
import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int initialTabIndex;

  const BottomNavBar({required this.initialTabIndex, Key? key})
      : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState(initialTabIndex);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page;

  _BottomNavBarState(this._page);

  final tabs = [
    BuyScreen(),
    SellScreen(),
    ScanScreen(),
    FoodMartScreen(),
    ArticleScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (_page == -1) {
      _page = widget.initialTabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: blueColor,
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.shopping_bag,
              color: whiteColor,
            ),
            label: 'Buy',
            labelStyle: TextStyle(color: whiteColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.sell,
              color: whiteColor,
            ),
            label: 'Sell',
            labelStyle: TextStyle(color: whiteColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.camera_alt,
              color: whiteColor,
            ),
            label: 'Scan',
            labelStyle: TextStyle(color: whiteColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.store,
              color: whiteColor,
            ),
            label: 'Mart',
            labelStyle: TextStyle(color: whiteColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.article,
              color: whiteColor,
            ),
            label: 'Articles',
            labelStyle: TextStyle(color: whiteColor),
          ),
        ],
        height: 60,
        color: blueColor,
        buttonBackgroundColor: blueColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
        index: _page,
      ),
      body: tabs[_page],
    );
  }
}
