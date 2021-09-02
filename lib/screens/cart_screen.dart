import 'package:flutter/material.dart';
import '../providers/cart_prodiver.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
          itemCount: cart.itemCount,
          itemBuilder: (ctx, i) => CartItem(
              cart.items.values.toList()[i].id,
              cart.items.values.toList()[i].price,
              cart.items.values.toList()[i].quantity,
              cart.items.values.toList()[i].title),
        )),
        SizedBox(
          height: 10,
        ),
        Card(
          margin: EdgeInsets.all(15.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount}',
                    style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                TextButton(
                  child: Text('ORDER NOW'),
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
