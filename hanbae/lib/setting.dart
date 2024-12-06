import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메세지',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('차단한 메세지 관리'),
              onTap: () {
                // 차단한 메세지 관리 페이지로 이동하는 기능 추가 가능
              },
            ),
            ListTile(
              title: Text('수신 및 발신 설정'),
              onTap: () {
                // 수신 및 발신 설정 페이지로 이동하는 기능 추가 가능
              },
            ),
            ListTile(
              title: Text('차단한 사용자 관리'),
              onTap: () {
                // 차단한 사용자 관리 페이지로 이동하는 기능 추가 가능
              },
            ),
            SizedBox(height: 32),
            Text(
              '기타 설정',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('알림 설정'),
              onTap: () {
                // 알림 설정 페이지로 이동하는 기능 추가 가능
              },
            ),
            ListTile(
              title: Text('개인정보 보호 설정'),
              onTap: () {
                // 개인정보 보호 설정 페이지로 이동하는 기능 추가 가능
              },
            ),
          ],
        ),
      ),
    );
  }
}
