import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/utils/routes.dart';

import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageURL),
      ),
      trailing: FittedBox(
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(editProductRoute, arguments: product.id);
            },
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () {
              Provider.of<Products>(context, listen: false)
                  .deleteProduct(product.id);
            },
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
      title: Text(product.title),
    );
  }
}
