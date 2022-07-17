import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/utils/routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (context, product, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: GridTileBar(
              leading: IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavouriteStatus();
                },
                color: Theme.of(context).accentColor,
              ),
              backgroundColor: Colors.black87,
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, productDetails,
                    arguments: {'product': product.id});
              },
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
