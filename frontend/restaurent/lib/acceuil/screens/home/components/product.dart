import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import '../../../constants.dart';

class Products extends StatelessWidget {
  const Products({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  final Product product;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding / 2),
      child: InkWell(
        onTap: press,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    'http://127.0.0.1:8000${product.image}',  // Utilisation correcte de `product.image`
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                AutoSizeText(
                  product.title,
                  maxLines: 2,
                  minFontSize: 14,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Action à effectuer lorsqu'on clique sur l'icône du panier
                      },
                      icon: Icon(Icons.shopping_cart),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
