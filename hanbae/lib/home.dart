import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'search.dart';
import 'navigation_bar.dart';
import 'add.dart';
import 'user.dart';
import 'login.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');

  String selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '한배',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFC7EDFE),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFC7EDFE),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/hanbaeMenuLogo.png',
                    width: 120,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/hanbaeLogo.png',
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('홈'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('검색'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('사용자'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(context),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Color(0xFFC7EDFE),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton('전체'),
                  _buildCategoryButton('한식'),
                  _buildCategoryButton('중식'),
                  _buildCategoryButton('일식'),
                  _buildCategoryButton('양식'),
                  _buildCategoryButton('분식'),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: selectedCategory == '전체'
                  ? _postsRef.snapshots()
                  : _postsRef
                      .where('category', isEqualTo: selectedCategory)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List posts = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index];
                      String category = post['category'] ?? 'Korean';
                      var timestamp = post['timestamp'];

                      String formattedDate = '';
                      if (timestamp is Timestamp) {
                        DateTime dateTime = timestamp.toDate();
                        formattedDate =
                            DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
                      } else if (timestamp is String) {
                        DateTime dateTime = DateTime.parse(timestamp);
                        formattedDate =
                            DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
                      } else {
                        formattedDate = '시간 없음';
                      }

                      String imagePath;
                      switch (category) {
                        case '한식':
                          imagePath = 'assets/Korean.png';
                          break;
                        case '일식':
                          imagePath = 'assets/Japanese.png';
                          break;
                        case '중식':
                          imagePath = 'assets/Chinese.png';
                          break;
                        case '양식':
                          imagePath = 'assets/Western.png';
                          break;
                        case '분식':
                          imagePath = 'assets/Snack.png';
                          break;
                        default:
                          imagePath = 'assets/Korean.png';
                          break;
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(post: post),
                            ),
                          );
                        },
                        child: PostCard(
                          food: post['food'] ?? '제목 없음',
                          timestamp: formattedDate,
                          imageUrl: imagePath,
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('저장된 글이 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
        },
        label: Row(
          children: [
            Icon(Icons.edit),
            SizedBox(width: 5),
            Text('글쓰기'),
          ],
        ),
        backgroundColor: Color(0xFFC7EDFE),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        child: Text(
          category,
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category
              ? Color(0xFF0B9FE4)
              : Color(0xFF90CAF9),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String food;
  final String timestamp;
  final String imageUrl;

  const PostCard({
    required this.food,
    required this.timestamp,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 120,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    food,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    timestamp,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
