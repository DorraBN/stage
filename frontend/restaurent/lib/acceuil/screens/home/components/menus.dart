import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:restaurent/acceuil/screens/home/components/payement.dart';

class MenuPage1 extends StatefulWidget {
  const MenuPage1({Key? key}) : super(key: key);

  @override
  _MenuPage1State createState() => _MenuPage1State();
}

class _MenuPage1State extends State<MenuPage1> {
  late Future<List<Map<String, dynamic>>> futureProduct;
  List<Map<String, dynamic>> selectedProducts = [];
  int productCounter = 0;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  Future<List<Map<String, dynamic>>> fetchProduct() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> fetchProductDetails(int id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/productdetails/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  void _showProductDetails(Map<String, dynamic> product) async {
    try {
      final productDetails = await fetchProductDetails(product['id']);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Icon(Icons.info, size: 36, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(productDetails['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            content: Container(
              color: const Color.fromARGB(255, 60, 60, 60),
              width: 380,
              height: 390,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (productDetails['image'] != null)
                      Image.network(
                        productDetails['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 47, 46, 46),
                        child: Icon(Icons.image_not_supported),
                      ),
                    SizedBox(height: 10), // Add space between image and text
                    _buildDetailRow(Icons.person, "Name: ", productDetails['name']),
                    _buildDetailRow(Icons.category, "Category: ", productDetails['category']),
                    _buildDetailRow(Icons.description, "Description: ", productDetails['description']),
                    _buildDetailRow(Icons.attach_money, "Price: ", productDetails['price'].toString()),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error fetching product details: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load product details.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      selectedProducts.add(product);
      productCounter++;
    });
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
@override
Widget build(BuildContext context) {
  double totalPrice = selectedProducts.fold(
    0.0,
    (sum, product) => sum + (double.tryParse(product['price'] ?? '0.0') ?? 0.0) * (product['quantity'] ?? 1),
  );

  return Scaffold(
    appBar: AppBar(
      title: Text("Products"),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: Colors.green),
          onPressed: () {
            // Action à définir pour l'icône de menu
          },
        ),
      ],
    ),
    body: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 51, 51, 51),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 57, 57, 57),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          item: snapshot.data![index],
                          onView: () => _showProductDetails(snapshot.data![index]),
                          onAddToCart: () => _addToCart(snapshot.data![index]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 50, 49, 49),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products in Cart: $productCounter',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        final product = selectedProducts[index];
                        return ListTile(
                          leading: ClipOval(
                            child: product['image'] != null
                                ? Image.network(
                                    product['image'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.grey,
                                    child: Icon(Icons.image_not_supported, size: 24, color: Colors.white),
                                  ),
                          ),
                          title: Text(product['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Text('Price: ${product['price']}', style: TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    if (product['quantity'] > 1) {
                                      product['quantity']--;
                                    } else {
                                      selectedProducts.removeAt(index);
                                    }
                                    productCounter = selectedProducts.length;
                                    totalPrice = selectedProducts.fold(
                                      0.0,
                                      (sum, product) => sum + (double.tryParse(product['price'] ?? '0.0') ?? 0.0) * (product['quantity'] ?? 1),
                                    );
                                  });
                                },
                              ),
                              Text(
                                (product['quantity'] ?? 1).toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    product['quantity'] = (product['quantity'] ?? 1) + 1;
                                    totalPrice = selectedProducts.fold(
                                      0.0,
                                      (sum, product) => sum + (double.tryParse(product['price'] ?? '0.0') ?? 0.0) * (product['quantity'] ?? 1),
                                    );
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedProducts.removeAt(index);
                                    productCounter = selectedProducts.length;
                                    totalPrice = selectedProducts.fold(
                                      0.0,
                                      (sum, product) => sum + (double.tryParse(product['price'] ?? '0.0') ?? 0.0) * (product['quantity'] ?? 1),
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                selectedProducts: selectedProducts,
                                totalPrice: totalPrice,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              'continue ->',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          width: 120,
                          alignment: Alignment.center,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onView;
  final VoidCallback onAddToCart;

  const ProductCard({Key? key, required this.item, required this.onView, required this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: item['image'] != null
                ? Image.network(
  item['image'] ?? '',
  height: 150,
  width: double.infinity,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Center(child: Icon(Icons.image_not_supported, size: 50));
  },
  loadingBuilder: (context, child, progress) {
    if (progress == null) {
      return child;
    } else {
      return Center(child: CircularProgressIndicator());
    }
  },
)
                : Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Icon(Icons.image_not_supported),
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 33, 33, 34),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  item['name'],
                  maxLines: 1,
                  minFontSize: 14,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                AutoSizeText(
                  'Price: ${item['price'].toString()}',
                  maxLines: 1,
                  minFontSize: 12,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.green),
                      onPressed: onAddToCart,
                    ),
                    IconButton(
                      icon: Icon(Icons.visibility, color: Colors.blue),
                      onPressed: onView,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
