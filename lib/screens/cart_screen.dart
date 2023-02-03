import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Column(children: <Widget>[
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    "\u{20B9} ${cart.totalAmount}",
                  ),
                  backgroundColor: Colors.blue,
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<Orders>(context, listen: false)
                        .addOrder(cart.items.values.toList(), cart.totalAmount);
                    cart.clearCart();
                  },
                  child: const Text('ORDER NOW'),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: ((context, i) => Cart_Item(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].quantity)),
            itemCount: cart.itemCount,
          ),
        )
      ]),
    );
  }
}
