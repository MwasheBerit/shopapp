import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/edit_prodcut_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

import '../providers/product.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(context) async{
   await  Provider.of<Products>(context,listen:false).fetchAndSetProducts();

  }

  const UserProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Your products'), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ]),
        drawer: Appdrawer(),
        body: RefreshIndicator(
          onRefresh:()=>_refreshProducts(context),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productsData.item.length,
                  itemBuilder: (_, i) => Column(children: [
                        UserProductItem(
                          id:productsData.item[i].id,
                            title: productsData.item[i].title,
                            imageUrl: productsData.item[i].ImageUrl),
                        Divider(),
                      ]))),
        ));
  }
}
