import 'package:flutter/material.dart';
import 'package:firebase/Views/Foodmart/Tabs/Buy/food_buy.dart';
import 'package:firebase/Views/Foodmart/Tabs/Sell/food_sell.dart';
import 'package:firebase/colors.dart';

class FoodMartScreen extends StatefulWidget {
  FoodMartScreen({Key? key}) : super(key: key);

  @override
  State<FoodMartScreen> createState() => _FoodMartScreenState();
}

class _FoodMartScreenState extends State<FoodMartScreen> {
  TextEditingController searchController = TextEditingController();

  bool _isSearching = false;
  String _query = '';
  int _selectedIndex = 0;

  Widget _buildSearchField() {
    return TextFormField(
      controller: searchController,
      style: TextStyle(color: whiteColor),
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search Birds...',
        border: InputBorder.none,
      ),
      onChanged: (query) {
        setState(() {
          _query = query;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching ? _buildSearchField() : const Text('Food Mart'),
          actions: _selectedIndex == 0
              ? [
                  IconButton(
                    icon: Icon(_isSearching ? Icons.cancel : Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          searchController.clear();
                        }
                      });
                    },
                  ),
                ]
              : null,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: const Color(0xfff5d04f),
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
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            FoodBuyScreen(
              query: _query.toString(),
            ),
            FoodSellScreen(),
          ],
        ),
      ),
    );
  }
}
