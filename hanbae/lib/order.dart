import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_store.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final _formKey = GlobalKey<FormState>();
  final _foodController = TextEditingController();
  String? _selectedStore;
  List<Map<String, String>> _stores = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  // 가게 목록 가져오기
  Future<void> _fetchStores() async {
    var snapshot = await FirebaseFirestore.instance.collection('stores').get();
    setState(() {
      _stores = snapshot.docs.map((doc) {
        return {
          'name': doc['name'] as String,
          'category': doc['category'] as String,
        };
      }).toList();
    });
  }

  // 주문 추가
  Future<void> _addOrder() async {
    if (!_formKey.currentState!.validate() || _selectedStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 작성해주세요!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 선택한 가게의 category 값을 찾기
      var selectedStore = _stores.firstWhere(
          (store) => store['name'] == _selectedStore,
          orElse: () => {'category': 'Unknown'});

      // Firestore에 주문 저장
      await FirebaseFirestore.instance.collection('posts').add({
        'food': _foodController.text,
        'store': _selectedStore,
        'category': selectedStore['category'], // category 추가
        'timestamp': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주문이 저장되었습니다!')),
      );

      _foodController.clear();
      setState(() {
        _selectedStore = null;
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 음식 이름 입력
          TextFormField(
            controller: _foodController,
            decoration: const InputDecoration(
              hintText: '같이 시킬 음식을 작성해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '음식을 작성해주세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          // 가게 선택 드롭다운
          DropdownButtonFormField<String>(
            value: _selectedStore,
            onChanged: (newValue) {
              setState(() {
                _selectedStore = newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: '가게를 선택해주세요',
            ),
            items: _stores.map((store) {
              return DropdownMenuItem<String>(
                value: store['name'],
                child: Text(store['name']!),
              );
            }).toList(),
          ),
          // 가게가 없으면 추가 페이지로 이동하는 버튼
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStorePage()),
              );
              _fetchStores(); // 새 가게 추가 후 데이터 갱신
            },
            child: Text('찾으시는 가게가 없나요?'),
          ),
          const SizedBox(height: 16),
          // 저장 버튼
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _addOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC7EDFE),
                  ),
                  child: const Text('저장하기'),
                ),
        ],
      ),
    );
  }
}
