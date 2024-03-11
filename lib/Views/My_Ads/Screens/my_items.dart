import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Views/My_Ads/Edit_screens/edit_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Views/Foodmart/Tabs/Buy/food_product_view.dart'; // Import your product view
import 'package:firebase/colors.dart';

class MyItems extends StatelessWidget {
  final String currentUserUid;

  const MyItems({Key? key, required this.currentUserUid}) : super(key: key);

  Stream<QuerySnapshot> fetchData() async* {
    yield* FirebaseFirestore.instance
        .collection("FoodAdds")
        .where("uid", isEqualTo: currentUserUid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Items"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final postMap =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final imageUrl = postMap['foodPic'] ?? '';
                final name = postMap['name'] ?? 'Name not available';
                final price = postMap['price'] ?? 'Price not available';

                void deleteItem() {
                  FirebaseFirestore.instance
                      .collection("FoodAdds")
                      .doc(snapshot.data!.docs[index].id)
                      .delete();
                }

                void editItem() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditItemsScreen(
                        adId: snapshot.data!.docs[index].id,
                        initialData: postMap,
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodProductView(
                          image: imageUrl,
                          name: name,
                          description: postMap["discription"],
                          address: postMap["address"],
                          price: price,
                          contact: postMap["contact"],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Placeholder(), // Show a placeholder if no image available
                      title: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "\$$price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: editItem,
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                          IconButton(
                            onPressed: deleteItem,
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
