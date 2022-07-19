import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/widgets/order_list_item.dart';
import 'package:shop/widgets/side_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: const SideDrawer(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) {
            return OrderListItem(order: orderData.orders[index]);
          }),
    );
  }
}
