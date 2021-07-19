import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String url;
  bool isFavorite = false;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.url,
      this.isFavorite = false});

  void _setIsFavorite(bool isFavoriteValue) {
    isFavorite = isFavoriteValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    _setIsFavorite(!isFavorite);
    try {
      final url =
          'https://flutter-shop-app-86f4f-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token';
      final res = await http.put(Uri.parse(url),
          body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        throw HttpException('Add to favorite failed');
      }
    } catch (e) {
      _setIsFavorite(oldStatus);
      throw e;
    }
  }
}
