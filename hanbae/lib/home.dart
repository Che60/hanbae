import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth 추가
import 'search.dart';
import 'navigation_bar.dart';
import 'add.dart';
import 'user.dart';
import 'login.dart'; // login.dart 페이지 import

class HomePage extends StatelessWidget {
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('한배'),
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
            icon: Icon(Icons.notifications),
            onPressed: () {
              // 알림 기능 추가
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
              leading: Icon(Icons.logout),
              title: Text('로그아웃'),
              onTap: () async {
                await FirebaseAuth.instance.signOut(); // Firebase에서 로그아웃 처리
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()), // 로그인 페이지로 이동
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(context),
      body: StreamBuilder(
        stream: _postsRef.snapshots(),
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
                String category = post['category'] ?? 'Korean'; // 기본값 'Korean'
                String timestamp = post['timestamp'] ?? '시간 없음';

                // 카테고리별 이미지 경로 설정
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

                return PostCard(
                  food: post['food'] ?? '제목 없음',
                  timestamp: timestamp,
                  imageUrl: imagePath,
                );
              },
            );
          } else {
            return Center(child: Text('저장된 글이 없습니다.'));
          }
        },
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
                    timestamp, // 작성 시간 표시
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
