import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductOverview extends StatefulWidget {
  ProductOverview({Key? key}) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showFavouriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favourites) {
                    _showFavouriteOnly = true;
                  } else {
                    _showFavouriteOnly = false;
                  }
                });
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.favourites,
                  child: Text('Only Favourites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show all'),
                ),
              ],
            ),
          ],
        ),
        body: ProductGridView(
          showFavourite: _showFavouriteOnly,
        ));
  }
}
