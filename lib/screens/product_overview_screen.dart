import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/routes.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/side_drawer.dart';
import '../provider/cart.dart';
import '../provider/products_provider.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({Key? key}) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showFavouriteOnly = false;
  var _init = true;
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then(
    //   (_) {
    //     final product = Provider.of<Products>(context);
    //     product.fetchAndSetProducts();
    //   },
    // );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

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
            Consumer<Cart>(
              builder: (context, cartData, child) {
                return Badge(
                  value: cartData.itemCount,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(cartScreen);
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: const SideDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductGridView(
                showFavourite: _showFavouriteOnly,
              ));
  }
}
