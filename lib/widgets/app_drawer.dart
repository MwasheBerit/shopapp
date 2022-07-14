import 'package:flutter/material.dart';
import 'package:shopapp/screens/ordersScreen.dart';
import 'package:shopapp/screens/user_product_screen.dart';

class Appdrawer extends StatelessWidget {
  const Appdrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Tello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              }),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              })
        ],
      ),
    );
  }
}
