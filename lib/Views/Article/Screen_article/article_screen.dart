import 'package:firebase/Views/Article/Tabs/reed_article.dart';
import 'package:firebase/Views/Article/Tabs/post_article.dart';
import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

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
              "Articles",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: blueColor,
            bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                indicatorColor: const Color(0xfff5d04f),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.article_outlined,
                      color: whiteColor,
                    ),
                    child: Text(
                      "Read",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.post_add,
                      color: whiteColor,
                    ),
                    child: Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
          ),
          body:
              TabBarView(children: [ArticleReadScreen(), PostArticleScreen()]),
        ));
  }
}
