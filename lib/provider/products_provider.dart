import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/model/http_exceptions.dart';
import 'package:shop/model/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavouriteProductsOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItem {
    return _items.where((element) => element.isFavourite).toList();
  }

  // void showFavouritesOnly() {
  //   _showFavouriteProductsOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouriteProductsOnly = false;
  //   notifyListeners();
  // }

  Product findByID(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product p) {
    final url = Uri.parse(
        "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
    return http
        .post(
      url,
      body: json.encode(
        {
          'title': p.title,
          'description': p.description,
          'imageURL': p.imageURL,
          'price': p.price,
          'isFavourite': p.isFavourite,
        },
      ),
    )
        .then(
      (value) {
        final newProduct = Product(
          description: p.description,
          title: p.title,
          imageURL: p.imageURL,
          price: p.price,
          id: json.decode(value.body)['name'],
        );
        _items.add(newProduct);
        notifyListeners();
      },
    ).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(Product prod) async {
    try {
      final url = Uri.parse(
          "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/products/${prod.id}.json");
      await http.patch(
        url,
        body: json.encode(
          {
            'title': prod.title,
            'description': prod.description,
            'imageURL': prod.imageURL,
            'price': prod.price,
            'isFavourite': prod.isFavourite,
          },
        ),
      );
      final index = _items.indexWhere((element) => element.id == prod.id);
      _items[index] = prod;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/products.json");
    try {
      final response = await http.get(url);
      final extractedProduct =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedProduct.forEach((key, value) {
        loadedProducts.add(
          Product(
            description: value['description'],
            title: value['title'],
            imageURL: value['imageURL'],
            price: value['price'],
            id: key,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shop-b4ec7-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    http.delete(url).then((value) {
      if (value.statusCode >= 400) {
        throw HttpException(message: "Something went wrong");
      }
      notifyListeners();
    }).catchError(
      (onError) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
      },
    );
  }
}
