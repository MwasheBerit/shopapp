import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/cartscreen.dart';
import 'package:shopapp/screens/edit_prodcut_screen.dart';
import 'package:shopapp/screens/ordersScreen.dart';
import 'package:shopapp/screens/product_details.dart';
import 'package:shopapp/screens/product_overview_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import './providers/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx) => Orders())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            primaryColor: Colors.lightBlue[800],
            iconTheme: IconThemeData(color: Colors.purple[400]),
            fontFamily: 'QuickSand',
          ),
          home: ProductOverview(),
          routes: {
            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartScreen.routeName: ((context) => CartScreen()),
            OrderScreen.routeName: ((context) => OrderScreen()),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName:(ctx)=>EditProductScreen(),
          }),
    );
  }
}
