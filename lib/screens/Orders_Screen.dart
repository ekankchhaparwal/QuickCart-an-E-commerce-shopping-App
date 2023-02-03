import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/Drawer.dart';
import 'package:shopping_app/widgets/IndividualOrders.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class MyFinalOrders extends StatelessWidget {
  static const routeNamed = '/orders';
  @override
  Widget build(BuildContext context) {
    final Myorders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY ORDERS'),
      ),
      drawer: DrawerScreen(),
      body: ListView.builder(
        itemBuilder: ((context, index) =>
            OrderItemsFinal(Myorders.orders[index])),
        itemCount: Myorders.orders.length,
      ),
    );
  }
}
