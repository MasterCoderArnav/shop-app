import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pm =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final prodID = pm['product'];
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findByID(prodID!);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(),
    );
  }
}
