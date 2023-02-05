import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndStoreProducts() async {
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodct) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodct['title'],
          description: prodct['description'],
          price: prodct['price'],
          imageUrl: prodct['imageUrl'],
          isFavourite: prodct['isFavourite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProducts(Product product) async {
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final indexId = _items.indexWhere((element) => element.id == id);
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/products/$id.json');
    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavourite': product.isFavourite,
        }));
    if (indexId >= 0) {
      _items[indexId] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async{
    var url = Uri.https(
        'shopping-app-a43f2-default-rtdb.firebaseio.com', '/products/$id.json');
    http.delete(url).then((value) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
      
    });
  }
}
