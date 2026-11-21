import 'package:flutter/foundation.dart';

class ShoppingItem {
  ShoppingItem({required this.id, required this.name, this.isPurchased = false});
  final int id;
  final String name;
  bool isPurchased;
}

class DaftarBelanjaModel extends ChangeNotifier {
  final List<ShoppingItem> _items = [];
  List<ShoppingItem> get items => List.unmodifiable(_items);

  void add(String name) {
    final value = name.trim();
    if (value.isEmpty) return;
    _items.insert(0, ShoppingItem(id: DateTime.now().microsecondsSinceEpoch, name: value));
    notifyListeners();
  }

  void toggle(int id) {
    final item = _items.firstWhere((value) => value.id == id);
    item.isPurchased = !item.isPurchased;
    notifyListeners();
  }

  void remove(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
