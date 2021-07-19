import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'dart:convert';

//with - mixin
class Products with ChangeNotifier {
  final baseUrl =
      'https://flutter-shop-app-86f4f-default-rtdb.europe-west1.firebasedatabase.app/';
  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool isFilteredByUser = false]) async {
    final query = isFilteredByUser ? 'orderBy="creatorId"&equalTo="$userId"&' : '';
    final url = baseUrl + 'products.json?${query}auth=$authToken';
    try {
      final res = await http.get(Uri.parse(url));
      final Map<String, dynamic>? extractedData = json.decode(res.body);
      if (extractedData == null) return;
      final favUrl =
          'https://flutter-shop-app-86f4f-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json/?auth=$authToken';
      final favoriteRes = await http.get(Uri.parse(favUrl));
      final Map<String, dynamic>? favoriteData = json.decode(favoriteRes.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          url: prodData['imageUrl'],
          isFavorite: favoriteData?[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = baseUrl + 'products.json?auth=$authToken';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.url,
            'price': product.price,
            'creatorId': userId,
          }));

      ///необходимо указать тип во избежание ошибок
      ///допускается также применение as Map<String, dynamic>
      final Map<String, dynamic> data = jsonDecode(res.body);
      final newProduct = Product(
          id: data['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          url: product.url);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final idx = _items.indexWhere((element) => element.id == id);
    if (idx > -1) {
      try {
        final url = '${baseUrl}products/$id.json?auth=$authToken';
        final res = await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.url,
              'price': newProduct.price,
            }));
        if (res.statusCode >= 400) {
          throw HttpException('Could not update product');
        }
        _items[idx] = newProduct;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = '${baseUrl}products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    dynamic existingProduct = _items[existingProductIndex];

    ///remove from the list, but not from the memory
    ///because someone is still interesting with this object
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    ///clear the memory
    existingProduct = null;
  }
}
