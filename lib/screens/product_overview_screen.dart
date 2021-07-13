import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum EFilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: EFilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: EFilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (EFilterOptions selectedValue) {
              if(selectedValue == EFilterOptions.Favorites) {
                productsData.showFavoritesOnly();
              } else {
                productsData.showAll();
              }
            },
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
