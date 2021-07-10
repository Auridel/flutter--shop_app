import 'package:flutter/material.dart';

import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  final double price;

  ProductItem(
      {required this.id, required this.title, required this.imageUrl, required this.price})
      : super(key: Key(id));

  @override
  Widget build(BuildContext context) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => ProductDetailScreen(title: title,)));
            },
          ),
          header: Text(price.toString()),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => null,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => null,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            backgroundColor: Colors.black87,
          ),
        ),
      );
}
