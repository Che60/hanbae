import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_store.dart';
import 'navigation_bar.dart';

class ShopListPage extends StatelessWidget {
  final CollectionReference _storesRef =
      FirebaseFirestore.instance.collection('stores');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '가게 리스트',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFC7EDFE),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStorePage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: Text(
              '추가',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _storesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List stores = snapshot.data!.docs;

            Map<String, List> categorizedStores = {};

            for (var store in stores) {
              String name = store['name'];
              String category = store['category'];

              if (!categorizedStores.containsKey(category)) {
                categorizedStores[category] = [];
              }

              if (!categorizedStores[category]!
                  .any((item) => item['name'] == name)) {
                categorizedStores[category]!.add({
                  'name': name,
                  'category': category,
                });
              }
            }

            return ListView.builder(
              itemCount: categorizedStores.keys.length,
              itemBuilder: (context, index) {
                String category = categorizedStores.keys.elementAt(index);
                List storesInCategory = categorizedStores[category]!;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 11, 159, 228),
                        ),
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: storesInCategory.length,
                        itemBuilder: (context, index) {
                          var store = storesInCategory[index];
                          return Card(
                            color: Color(0xFFC7EDFE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                store['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('저장된 가게가 없습니다.'));
          }
        },
      ),
      bottomNavigationBar: CustomNavigationBar(context),
    );
  }
}
