import 'package:flutter/material.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGridView extends StatelessWidget {
  final bool showFavourite;
  const ProductGridView({
    Key? key,
    required this.showFavourite,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final product =
        showFavourite ? productsData.favouriteItem : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: product.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: product[index],
          child: const ProductItem(),
        );
      },
    );
  }
}
