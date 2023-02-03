import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import '../screens/cart_screen.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import 'package:shopping_app/screens/user_productscreen.dart';
import './screens/product_overview_screen.dart';
import './providers/product_providers.dart';
import 'package:provider/provider.dart';
import './screens/Orders_Screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.namedRoute: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          MyFinalOrders.routeNamed :(context) => MyFinalOrders(),
          UserProductScreen.routeName :(context) => UserProductScreen(),
          EditProductScreen.routeName : (context) => EditProductScreen(),
        },
      ),
    );
  }
}
