import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final String imageURL;
  final double price;
  bool isFavourite = false;
  Product({
    required this.description,
    required this.title,
    required this.imageURL,
    required this.price,
    required this.id,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  void toggleFavouriteStatus(String authToken, String userID) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    final url = Uri.parse(
        "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourite/$userID/$id.json?auth=$authToken");
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
    notifyListeners();
  }
}
