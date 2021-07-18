import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final url =
          'https://flutter-shop-app-86f4f-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
      final res = await http.get(Uri.parse(url));
      final Map<String, dynamic>? resData = json.decode(res.body);
      final List<OrderItem> loadedOrders = [];
      if(resData == null) return;
      resData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            id: key,
            amount: value['amount'],
            products: (value['products'] as List<dynamic>)
                .map((el) => CartItem(
                    id: el['id'],
                    title: el['title'],
                    price: el['price'],
                    quantity: el['quantity']))
                .toList(),
            dateTime: DateTime.parse(value['dateTime'])));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final url =
          'https://flutter-shop-app-86f4f-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
      final timestamp = DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((prod) => {
                      'id': prod.id,
                      'title': prod.title,
                      'price': prod.price,
                      'quantity': prod.quantity,
                    })
                .toList(),
          }));
      final Map<String, dynamic> resData = json.decode(res.body);
      _orders.insert(
          0,
          OrderItem(
              id: resData['name'],
              amount: total,
              products: cartProducts,
              dateTime: timestamp));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
