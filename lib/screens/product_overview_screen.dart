import 'package:flutter/material.dart';

import 'package:shop_app/models/product.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = [
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('My shop'),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: loadedProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, idx) => ProductItem(
            id: loadedProducts[idx].id,
            title: loadedProducts[idx].title,
            imageUrl: loadedProducts[idx].url,
          ),
        ),
      );
}
