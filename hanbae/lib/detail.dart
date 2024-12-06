import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final dynamic post;

  const DetailPage({required this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final CollectionReference _commentsRef =
      FirebaseFirestore.instance.collection('comments');

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      await _commentsRef.add({
        'postId': widget.post.id,
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    String category = post['category'] ?? '기타';
    String food = post['food'] ?? '음식 없음';
    String store = post['store'] ?? '가게 없음';
    var timestamp = post['timestamp'];

    String formattedDate = '';
    if (timestamp is String) {
      try {
        DateTime dateTime = DateTime.parse(timestamp);
        formattedDate = DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
      } catch (e) {
        formattedDate = '시간 정보 오류';
      }
    } else {
      formattedDate = '시간 정보 없음';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          food,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFC7EDFE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              '가게: $store',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              '작성 시간: $formattedDate',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: '댓글을 남겨주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _addComment,
                child: Text('댓글 작성'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC7EDFE),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 1.0,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: _commentsRef
                  .where('postId', isEqualTo: post.id)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('댓글 로드 오류'));
                } else if (snapshot.hasData) {
                  var comments = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      var comment = comments[index];
                      return ListTile(
                        title: Text(comment['comment']),
                        subtitle: Text(DateFormat('yyyy.MM.dd HH:mm').format(
                          (comment['timestamp'] as Timestamp).toDate(),
                        )),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('댓글이 없습니다.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
