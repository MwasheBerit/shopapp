import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/app_drawer.dart';

import '../widgets/order_items.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) async {
    //   setState(() {
    //   _isLoading = true;
    // });
    await  Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //  setState(() {
    //   _isLoading = false;
    // });
    });
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // static const routeName='/orders';
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Your orders')),
        drawer: Appdrawer(),
        body:ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => OrderItem(orderData.orders[i])));
  }
}
