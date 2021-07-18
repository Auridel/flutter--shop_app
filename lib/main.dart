import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///combines providers to prevent providers hell
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ///here we can pass a value from previous provider
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProducts) => Products(auth.token ?? '', prevProducts?.items ?? []),
          create: (ctx) => Products('', []),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, prevOrders) => Orders(auth.token ?? '', prevOrders?.orders ?? []),
          create: (_) => Orders('', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
