import 'package:firebase/Views/My_Ads/Edit_screens/edit_articles.dart';
import 'package:firebase/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyArticles extends StatelessWidget {
  final String currentUserUid;

  const MyArticles({Key? key, required this.currentUserUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Posted Articles"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("article")
            .where("uid", isEqualTo: currentUserUid) // Add where clause
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final articleData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final title =
                      articleData["title"] ?? 'Title Is Not Available';
                  final description = articleData["description"] ??
                      'Description Is Not Available';
                  final imageUrl = articleData['articlePic'] ?? '';

                  void deleteArticle() async {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                    await FirebaseFirestore.instance
                        .collection("articlePosts")
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  }

                  void editArticle() {
                    // Navigate to edit screen with document ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditArticleScreen(
                          docId: snapshot.data!.docs[index].id,
                          title: title,
                          description: description,
                        ),
                      ),
                    );
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imageUrl
                            .isNotEmpty) // Check if imageUrl is not empty
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: editArticle,
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 16, color: whiteColor),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: blueColor,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: deleteArticle,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          fontSize: 16, color: whiteColor),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade500,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No data available.'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
