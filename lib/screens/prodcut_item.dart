import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shopapp/screens/product_details.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final snackBar = SnackBar(
        content: Text('YAdded item to cart'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            cart.removeSingleITem(product.id);
          },
        ));

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductDetails.routeName, arguments: product.id);
                // MaterialPageRoute(builder: (ctx) => ProductDetails(title)));
              },
              child: Image.network(product.ImageUrl, fit: BoxFit.contain)),
          footer: GridTileBar(
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                color: Theme.of(context).accentColor,
              ),
              backgroundColor: Colors.black87,
              title: Text(product.title, textAlign: TextAlign.center))),
    );
  }
}
