import 'package:flutter/material.dart';

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

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
