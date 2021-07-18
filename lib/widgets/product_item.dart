import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///alternative syntax
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false).token ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.url,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
        ),
        footer: GridTileBar(
          ///можно оборачивать только часть виджетов в консюмеров, чтобы избежать
          ///перерендера всего дерева
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline),
              onPressed: () async {
                try {
                  await product.toggleFavoriteStatus(authToken);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Add to favorite failed',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              color: Theme.of(context).accentColor,
            ),

            ///child argument for those part, that shouldn't update
            // child: Text('Never rerenders!!!'),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
