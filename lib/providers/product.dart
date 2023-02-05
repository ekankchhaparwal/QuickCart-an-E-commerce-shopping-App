import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite() async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/products/$id.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({"isFavourite": isFavourite}),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldstatus;
      }
    } catch (error) {
      isFavourite = oldstatus;
    }
    notifyListeners();
  }
}
