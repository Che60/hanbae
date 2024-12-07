import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final dynamic post; // Firestore에서 받아온 포스트 데이터

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

  void _deleteComment(String commentId) async {
    try {
      await _commentsRef.doc(commentId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 삭제 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    String category = post['category'] ?? '기타';
    String food = post['food'] ?? '음식 없음';
    String store = post['store'] ?? '가게 없음';
    var timestamp = post['timestamp'];

    // timestamp가 String일 경우 이를 DateTime으로 변환
    String formattedDate = '';
    if (timestamp is String) {
      try {
        DateTime dateTime = DateTime.parse(timestamp);
        formattedDate = DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
      } catch (e) {
        formattedDate = '시간 정보 오류'; // 날짜 변환 오류 처리
      }
    } else if (timestamp is Timestamp) {
      formattedDate = DateFormat('yyyy.MM.dd HH:mm').format(timestamp.toDate());
    } else {
      formattedDate = '시간 정보 없음'; // timestamp가 String이 아닌 경우
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
        title: Text(food),
        backgroundColor: Color(0xFFC7EDFE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 200, // 고정된 크기
                height: 200, // 고정된 크기
                fit: BoxFit.cover, // 정사각형에 맞게 이미지 크기 조정
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // 음식 이름 중앙 정렬
            ),
            SizedBox(height: 5),
            Text(
              '가게: $store',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center, // 가게 이름 중앙 정렬
            ),
            SizedBox(height: 5),
            Text(
              '작성 시간: $formattedDate', // 수정된 부분
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center, // 작성 시간 중앙 정렬
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
            // 댓글 작성 버튼 오른쪽 정렬
            Align(
              alignment: Alignment.centerRight, // 오른쪽 정렬
              child: ElevatedButton(
                onPressed: _addComment,
                child: Text('댓글 작성'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFFC7EDFE), // primary 대신 backgroundColor 사용
                ),
              ),
            ),
            SizedBox(height: 10), // 버튼과 Divider 사이의 여백
            Divider(
              thickness: 1.0, // Divider의 두께
              color: Colors.grey, // Divider 색상
            ),
            SizedBox(height: 10), // Divider와 댓글 리스트 사이의 여백

            // 댓글을 스크롤 가능한 영역으로 감쌈
            Expanded(
              child: SingleChildScrollView(
                // 전체 리스트가 스크롤 가능하도록 함
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: _commentsRef
                          .where('postId', isEqualTo: post.id)
                          .orderBy('timestamp')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('댓글 로드 오류'));
                        } else if (snapshot.hasData) {
                          var comments = snapshot.data!.docs;
                          return Column(
                            children: comments.map<Widget>((comment) {
                              var commentId = comment.id; // 댓글 ID
                              var commentTimestamp = comment['timestamp'];

                              // timestamp가 null인 경우 처리
                              DateTime commentDateTime;
                              if (commentTimestamp == null) {
                                commentDateTime = DateTime.now(); // 기본값 처리
                              } else if (commentTimestamp is Timestamp) {
                                commentDateTime = commentTimestamp.toDate();
                              } else {
                                commentDateTime = DateTime.now(); // 기본값 처리
                              }

                              return ListTile(
                                title: Text(comment['comment']),
                                subtitle: Text(DateFormat('yyyy.MM.dd HH:mm')
                                    .format(commentDateTime)),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.black),
                                  onPressed: () {
                                    // 삭제 버튼을 클릭했을 때 해당 댓글 삭제
                                    _deleteComment(commentId);
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Center(child: Text('댓글이 없습니다.'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
