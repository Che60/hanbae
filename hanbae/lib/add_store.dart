import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final _storeController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  // 드롭다운 항목
  final List<String> categories = [
    '한식',
    '일식',
    '중식',
    '양식',
    '분식',
  ];

  Future<void> _addStore() async {
    if (_storeController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가게 이름과 카테고리를 선택해주세요!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Firestore에 가게 추가
      await FirebaseFirestore.instance.collection('stores').add({
        'name': _storeController.text,
        'category': _selectedCategory,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가게가 추가되었습니다!')),
      );

      _storeController.clear();
      setState(() {
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장에 실패했습니다: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가게 추가'),
        backgroundColor: const Color(0xFFC7EDFE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _storeController,
              decoration: const InputDecoration(
                labelText: '가게 이름',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text('카테고리 선택'),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC7EDFE),
                    ),
                    child: const Text('저장하기'),
                  ),
          ],
        ),
      ),
    );
  }
}
