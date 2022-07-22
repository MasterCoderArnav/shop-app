import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/widgets/cart_grid_item.dart';
import '../provider/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Screen'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '\$${cart.cartTotal.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        TextButton(
                          onPressed: () async {
                            final order =
                                Provider.of<Order>(context, listen: false);
                            setState(() {
                              _isLoading = true;
                            });
                            await order.addOrder(
                                cart.item.values.toList(), cart.cartTotal);
                            setState(() {
                              _isLoading = false;
                            });
                            cart.clearCart();
                          },
                          child: Text(
                            'Order Now!',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (context, index) {
                      return CartGridItem(
                        cartItem: cart.item.values.toList()[index],
                        productID: cart.item.keys.toList()[index],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
