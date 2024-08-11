import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import '../../../constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      'http://127.0.0.1:8000${product.image}',
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
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  // Exemple de liste de produits
  final List<Product> products;

  const ProductCard({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Products(
          product: product,
          press: () {
            // Action à effectuer lorsqu'on clique sur le produit
          },
        );
      },
    );
  }
}
class Product {
  final String image;
  final String title;

  Product({required this.image, required this.title});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'],
      title: json['title'],
    );
  }
}

// Fonction pour obtenir les produits depuis l'API
Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}