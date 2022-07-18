import 'package:flutter/cupertino.dart';
import 'package:shop/provider/cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime dt;
  OrderItem({
    required this.id,
    required this.price,
    required this.products,
    required this.dt,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItem, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        price: total,
        products: cartItem,
        dt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
