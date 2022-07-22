// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/provider/orders.dart';
// import 'package:shop/widgets/order_list_item.dart';
// import 'package:shop/widgets/side_drawer.dart';

// class OrderScreenCopy extends StatefulWidget {
//   const OrderScreenCopy({Key? key}) : super(key: key);

//   @override
//   State<OrderScreenCopy> createState() => _OrderScreenCopyState();
// }

// class _OrderScreenCopyState extends State<OrderScreenCopy> {
//   var _init = true;
//   var _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_init) {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<Order>(context, listen: false)
//           .fetchAndSetOrders()
//           .then((value) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _init = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Orders'),
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       drawer: const SideDrawer(),
//       body: FutureBuilder(
//         future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               if (snapshot.hasError) {
//                 return const Center(
//                   child: Text('An error occured'),
//                 );
//               } else {
//                 return Consumer<Order>(
//                   builder: (context, orderData, child) {
//                     return ListView.builder(
//                       itemCount: orderData.orders.length,
//                       itemBuilder: (context, index) {
//                         return OrderListItem(order: orderData.orders[index]);
//                       },
//                     );
//                   },
//                 );
//               }
//             default:
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//           }
//         },
//       ),
//     );
//   }
// }
