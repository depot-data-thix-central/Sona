import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
