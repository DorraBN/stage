import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import 'package:restaurent/acceuil/screens/home/components/about.dart';
import 'package:restaurent/acceuil/screens/home/components/footer.dart';
import 'package:restaurent/acceuil/screens/home/components/menus.dart';
import 'package:restaurent/acceuil/screens/home/components/product.dart';
import 'package:restaurent/acceuil/screens/home/components/services_card.dart';
import 'package:restaurent/acceuil/screens/home/components/email_banner.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';


import '../../../../screens/dashboard/pages/menu.dart';
import '../../../constants.dart' as my_constants; 
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
class BodyContainer extends StatelessWidget {
  const BodyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(my_constants.kPadding),
      child: Column(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            child: AboutUsPage(),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: my_constants.kMaxWidth),
            child: Column(
              children: [
                ServicesCard(),
                Container(
                  height: 400,
                  child: RestaurantMenuPage(),
                ),
       SizedBox(height: 20),
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationForm()),
    );
  },
  icon: Icon(Icons.event, color: Colors.white),
  label: Text(
    'Reserve a table',
    style: TextStyle(
      fontSize: 14, // Increase font size
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  style: ElevatedButton.styleFrom(
    minimumSize: Size(100, 60), backgroundColor: Colors.orange, // Background color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Less rounded corners for a more rectangular shape
    ),
    elevation: 5, // Add elevation for shadow effect
  ),
),
  SizedBox(height: 40),
                Center(
                  child: Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Responsive(
                  desktop: ProductCard(
                    crossAxiscount: _size.width < 650 ? 2 : 3,
                    aspectRatio: _size.width < 650 ? 0.85 : 1.1,
                  ),
                  tablet: ProductCard(
                    crossAxiscount: _size.width < 825 ? 2 : 3,
                    aspectRatio: _size.width < 825 ? 0.85 : 1.1,
                  ),
                  mobile: ProductCard(
                    crossAxiscount: _size.width < 690 ? 2 : 3,
                    aspectRatio: _size.width < 560 ? 0.85 : 1.1,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuPage1()),
                    );
                  },
                  child: Text('see more'),
                ),
                SizedBox(height: 20),
                EmailBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class RestaurantMenuPage extends StatefulWidget {
  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  late Future<List<MenuItem>> futureMenuItems;

  @override
  void initState() {
    super.initState();
    futureMenuItems = fetchMenuItems();
  }

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));

    if (response.statusCode == 200) {
      final List<dynamic> itemsJson = json.decode(response.body);
      return itemsJson.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        leading: IconButton(
          icon: Icon(Icons.food_bank, color: Colors.amber),
          onPressed: () {
            // Add your menu toggle logic here
          },
        ),
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: futureMenuItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hero-slider-2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.network(
                        'http://127.0.0.1:8000${item.image}', // Corrected image URL
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red, size: 50);
                        },
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name),
                          Row(
                            children: [
                              Text('${item.price.toString()}€'),
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  // Add cart functionality here
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Text(item.category),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No menu found'));
          }
        },
      ),
    );
  }
}

class MenuItem {
  final String name;
  final String image;
  final double price;
  final String category;

  MenuItem({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] ?? 'Unknown Name',
      image: json['image_url'] ?? '/path/to/default_image.jpg', // Provide a default image path
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category'] ?? 'Unknown Category',
    );
  }
}





























class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.crossAxiscount = 3,
    this.aspectRatio = 1.1,
  }) : super(key: key);

  final int crossAxiscount;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products available'));
        } else {
          final products = snapshot.data!;
          return GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxiscount,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) => Products(
              press: () {},
              product: products[index],
            ),
            itemCount: products.length,
          );
        }
      },
    );
  }
}