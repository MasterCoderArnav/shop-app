import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helpers/custom_route.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/utils/routes.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
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
          const Divider(),
          ListTile(
            leading: IconButton(
              onPressed: () {
                auth.logOut();
              },
              icon: const Icon(Icons.exit_to_app),
            ),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
