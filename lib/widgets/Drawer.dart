import 'package:flutter/material.dart';
import '../screens/user_productscreen.dart';
import '../screens/Orders_Screen.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('How You Doing !?'),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Go To Store'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('MY Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MyFinalOrders.routeNamed);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
