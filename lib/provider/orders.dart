import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

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
  String authToken;
  String userID;
  List<OrderItem> _orders = [];
  Order(this.authToken, this.userID, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userID.json?auth=$authToken");
    try {
      final response = await http.get(url);
      final extractedProduct =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedProduct.isEmpty) {
        return;
      }
      final List<OrderItem> orderDummy = [];
      extractedProduct.forEach((key, value) {
        orderDummy.add(
          OrderItem(
            id: key,
            price: value['price'],
            dt: DateTime.parse(value['dt']),
            products: (value['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = orderDummy.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartItem> cartItem, double total) async {
    final url = Uri.parse(
        "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userID.json?auth=$authToken");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'price': total,
            'dt': DateTime.now().toIso8601String(),
            'products': cartItem
                .map(
                  (cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          price: total,
          products: cartItem,
          dt: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
