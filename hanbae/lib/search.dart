import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
        backgroundColor: Color(0xFFC7EDFE),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아감 (HomePage)
          },
        ),
      ),
      body: Center(
        child: Text('검색 페이지 콘텐츠를 여기에 추가하세요'),
      ),
    );
  }
}
