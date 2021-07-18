import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/Badge.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum EFilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
    ///Won't work!
    // Provider.of<Products>(context).fetchAndSetProducts();
    ///works with listen = false
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // });
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(!_isInit) {
      setState(() {
        _isLoading = true;
      });
      ///context is available everywhere is stateful widget
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (_) =>
            [
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
              setState(() {
                if (selectedValue == EFilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
              builder: (_, cart, builderChild) =>
                  Badge(
                      child: builderChild!,
                      value: cart.count.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }
              ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showOnlyFavorites),
    );
  }
}
