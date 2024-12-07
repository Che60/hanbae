import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'detail.dart'; // 추가된 임포트

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');
  String _searchQuery = '';
  String _selectedCategory = '전체';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  List<String> categories = ['전체', '한식', '일식', '중식', '양식', '분식'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _updateSearchQuery,
          decoration: InputDecoration(
            hintText: '음식, 가게, 카테고리 검색',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xFFC7EDFE),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (newCategory) {
                setState(() {
                  _selectedCategory = newCategory!;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_searchQuery.isEmpty)
            Center(
              child: Text(
                '검색어를 입력해 주세요.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: StreamBuilder(
                stream: _postsRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('오류 발생: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List posts = snapshot.data!.docs;

                    if (posts.isEmpty) {
                      return Center(child: Text('검색 결과가 없습니다.'));
                    }

                    var filteredPosts = posts.where((post) {
                      String food = (post['food'] ?? '').toLowerCase();
                      String category = (post['category'] ?? '').toLowerCase();
                      String store = (post['store'] ?? '').toLowerCase();

                      bool matchesSearch = food.contains(_searchQuery) ||
                          category.contains(_searchQuery) ||
                          store.contains(_searchQuery);

                      bool matchesCategory = _selectedCategory == '전체' ||
                          category == _selectedCategory.toLowerCase();

                      return matchesSearch && matchesCategory;
                    }).toList();

                    if (filteredPosts.isEmpty) {
                      return Center(child: Text('검색 결과가 없습니다.'));
                    }

                    return ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        var post = filteredPosts[index];
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
