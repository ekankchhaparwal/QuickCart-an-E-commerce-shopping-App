import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../providers/cart.dart';
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final String _token;
  Orders(this._token, this._orders);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSet() async {
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/orders.json',{'auth' : _token});
    final respone = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(respone.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((OrderID, Data) {
      loadedOrders.add(OrderItem(
        id: OrderID,
        amount: Data['amount'],
        products: (Data['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']),
            )
            .toList(),
        dateTime: DateTime.parse(
          Data['dateTime'],
        ),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/orders.json',{'auth' : _token});
    final DateTimeString = DateTime.now().toIso8601String();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': DateTimeString,
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now()),
    );
    notifyListeners();
  }
}
