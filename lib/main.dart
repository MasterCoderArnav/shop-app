import 'package:flutter/material.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';
import 'package:shop/utils/routes.dart';
import './provider/products_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products("", [], ""),
          update: (context, auth, previousProducts) => Products(
              auth.token != null ? auth.token! : "",
              previousProducts == null ? [] : previousProducts.items,
              auth.userID != null ? auth.userID! : ""),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (_) => Order("", "", []),
          update: (context, auth, previousOrder) => Order(
              auth.token != null ? auth.token! : "",
              auth.userID != null ? auth.userID! : "",
              previousOrder == null ? [] : previousOrder.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, value, _) {
          return MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: value.isAuth
                ? const ProductOverview()
                : FutureBuilder(
                    future: value.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              authRoute: (context) => const AuthScreen(),
              homeRoute: (context) => const ProductOverview(),
              productDetails: (context) => const ProductDetail(),
              cartScreen: (context) => const CartScreen(),
              orderRoute: (context) => const OrderScreen(),
              userProductRoute: (context) => const UserProductScreen(),
              editProductRoute: (context) => const EditProductScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
