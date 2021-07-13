import 'package:flutter/material.dart';
import 'product.dart';

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

  var _showFavoritesOnly = false;

  List<Product> get items {
    if(_showFavoritesOnly) {
      return _items.where((element) => element.isFavorite).toList();
    }
    return [..._items];
  }
  /// проблема такой реализации - при переходе на другой экран, который использует
  /// эти же данные фильтры останутся применены
  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}