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
      var selectedStore = _stores.firstWhere(
          (store) => store['name'] == _selectedStore,
          orElse: () => {'category': 'Unknown'});

      await FirebaseFirestore.instance.collection('posts').add({
        'food': _foodController.text,
        'store': _selectedStore,
        'category': selectedStore['category'],
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
          TextFormField(
            controller: _foodController,
            decoration: const InputDecoration(
              hintText: '같이 주문할 음식을 작성해주세요',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '앗! 주문할 음식을 작성해주세요!';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
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
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStorePage()),
              );
              _fetchStores();
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
                  child: const Text('작성 완료'),
                ),
        ],
      ),
    );
  }
}
