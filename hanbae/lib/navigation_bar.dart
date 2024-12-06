import 'package:flutter/material.dart';
import 'search.dart';
import 'home.dart';
import 'user.dart';

class CustomNavigationBar extends StatelessWidget {
  final BuildContext context;

  CustomNavigationBar(this.context);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xFFC7EDFE),
      child: Table(
        children: [
          TableRow(
            children: [
              _buildBottomNavItem(
                context,
                Icons.search, // 검색 아이콘
                '검색', // 텍스트
                () {
                  Navigator.push(
                    // push로 변경
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.directions_car, // '같이 배달' 아이콘
                '같이 배달', // 텍스트
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.person, // 사용자 아이콘
                '사용자',
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
