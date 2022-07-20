import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/utils/routes.dart';
import 'package:shop/widgets/side_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Product'),
        centerTitle: false,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(editProductRoute);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                UserProductItem(product: productsData.items[index]),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
