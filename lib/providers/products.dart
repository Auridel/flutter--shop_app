import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

//with - mixin
class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: "p1",
        title: 'Red shirt',
        description: 'It\'s a red!',
        price: 29.99,
        url:
            'https://imgprd19.hobbylobby.com/5/ba/61/5ba610f22c7cd6efb4e6c69387d938451a6c40e6/700Wx700H-633719-0320.jpg'),
    Product(
        id: 'p2',
        title: 'White Dress',
        description: 'It\'s a white!',
        price: 49.99,
        url:
            'https://assets.vogue.com/photos/6070c580f6400d6eae7735a5/1:1/w_1013,h_1013,c_limit/slide_.jpg'),
    Product(
        id: 'p3',
        title: 'Green jeans',
        description: 'It\'s a green!',
        price: 15.99,
        url: 'https://kosmo-shop.com/23075/-aesthetic-green-jeans.jpg'),
    Product(
        id: 'p4',
        title: 'Yellow hat',
        description: 'It\'s a yellow!',
        price: 5.99,
        url:
            'https://previews.123rf.com/images/vitalily73/vitalily731704/vitalily73170400185/76635632-woman-hat-isolated-on-white-background-women-s-beach-hat-colorful-hat-yellow-hat-.jpg')
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if(_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  /// проблема такой реализации - при переходе на другой экран, который использует
  /// эти же данные фильтры останутся применены
  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) {
    const url =
        'https://flutter-shop-app-86f4f-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    return http
        .post(Uri.parse(url),
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.url,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }))
        .then((res) {
      ///допускается также применение as Map<String, dynamic>
      final Map<String, dynamic> data = jsonDecode(res.body);
      final newProduct = Product(
          id: data['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          url: product.url);
      _items.add(newProduct);

      ///at the start of the list
      // _items.insert(0, product);
      notifyListeners();
    }).catchError((err) {
      print(err);
      throw err;
    });
  }

  void updateProduct(String id, Product newProduct) {
    final idx = _items.indexWhere((element) => element.id == id);
    if (idx > -1) {
      _items[idx] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}