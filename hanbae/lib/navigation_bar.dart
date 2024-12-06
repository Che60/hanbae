import 'package:flutter/material.dart';
import 'home.dart';
import 'user.dart';
import 'shop_list.dart';

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
                Icons.store,
                '가게',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShopListPage()),
                  );
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.directions_car,
                '같이 배달',
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              _buildBottomNavItem(
                context,
                Icons.person,
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
