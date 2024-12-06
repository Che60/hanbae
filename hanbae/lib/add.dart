import 'package:flutter/material.dart';
import 'order.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물 작성'),
        centerTitle: true,
        backgroundColor: const Color(0xFFC7EDFE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Order(),
      ),
    );
  }
}
