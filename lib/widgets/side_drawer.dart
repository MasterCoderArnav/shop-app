import 'package:flutter/material.dart';
import 'package:shop/utils/routes.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(homeRoute);
              },
              icon: const Icon(
                Icons.shop,
              ),
            ),
            title: const Text('Shop'),
          ),
          const Divider(),
          ListTile(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(orderRoute);
              },
              icon: const Icon(
                Icons.payment,
              ),
            ),
            title: const Text('Orders'),
          ),
          const Divider(),
          ListTile(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(userProductRoute);
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
            title: const Text('Manage Products'),
          ),
        ],
      ),
    );
  }
}
