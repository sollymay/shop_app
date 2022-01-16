import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_prodiver.dart';

class ProductItem extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem({this.id, this.title, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(

          leading: IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavoriteSatus();
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
              ));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
