import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};
  Map<String, CartItem> get item {
    return {..._item};
  }

  int get itemCount {
    return _item.length;
  }

  double get cartTotal {
    double total = 0.0;
    _item.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productID, double price, String title) {
    if (_item.containsKey(productID)) {
      _item.update(
        productID,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity + 1,
          price: value.price,
        ),
      );
    } else {
      _item.putIfAbsent(
        productID,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _item.remove(productID);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_item.containsKey(productID)) {
      return;
    } else {
      if (_item[productID]!.quantity > 1) {
        _item.update(
          productID,
          (value) => CartItem(
            id: value.id,
            title: value.title,
            quantity: value.quantity - 1,
            price: value.price,
          ),
        );
      } else {
        _item.remove(productID);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _item = {};
    notifyListeners();
  }
}
