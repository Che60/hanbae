import 'package:flutter/material.dart';
import 'navigation_bar.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자'),
        centerTitle: true,
        backgroundColor: Color(0xFFC7EDFE),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: CustomNavigationBar(context),
      body: Center(
        child: Text('사용자 페이지 콘텐츠를 여기에 추가하세요'),
      ),
    );
  }
}
