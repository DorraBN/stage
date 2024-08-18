import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:restaurent/screens/dashboard/pages/login1.dart';

class MenuPage3 extends StatefulWidget {
  const MenuPage3({Key? key}) : super(key: key);

  @override
  _MenuPage3State createState() => _MenuPage3State();
}

class _MenuPage3State extends State<MenuPage3> {
  late Future<List<Map<String, dynamic>>> futureMenu;
  List<Map<String, dynamic>> selectedMenus = [];
  int menuCounter = 0;

  @override
  void initState() {
    super.initState();
    futureMenu = fetchMenu();
  }

  Future<List<Map<String, dynamic>>> fetchMenu() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));

    if (response.statusCode == 200) {
      final List<dynamic> menusJson = json.decode(response.body);
      return menusJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<Map<String, dynamic>> fetchMenuDetails(int id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load menu details');
    }
  }

  void _showMenuDetails(Map<String, dynamic> menu) async {
    try {
      final menuDetails = await fetchMenuDetails(menu['id']);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Icon(Icons.info, size: 36, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(menuDetails['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    if (menuDetails['image_url'] != null)
                      Image.network(
                        menuDetails['image_url'],
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
                    _buildDetailRow(Icons.person, "Name: ", menuDetails['name']),
                    _buildDetailRow(Icons.category, "Category: ", menuDetails['category']),
                    _buildDetailRow(Icons.description, "Description: ", menuDetails['description']),
                    _buildDetailRow(Icons.attach_money, "Price: ", menuDetails['price'].toString()),
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
      print('Error fetching menu details: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load menu details.'),
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

  void _addToCart(Map<String, dynamic> menu) {
    setState(() {
      selectedMenus.add(menu);
      menuCounter++;
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
    double totalPrice = selectedMenus.fold(
      0.0,
      (sum, menu) => sum + (double.tryParse(menu['price'] ?? '0.0') ?? 0.0) * (menu['quantity'] ?? 1),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Menus"),
        actions: [
          Container(
            margin: EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () {
                // Action à définir pour le bouton Track Orders
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login1()), // Remplacez par la page cible
                );
              },
              icon: Icon(Icons.track_changes, color: Colors.white),
              label: Text(
                "Track Orders",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
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
                  future: futureMenu,
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
                          return MenuCard(
                            item: snapshot.data![index],
                            onView: () => _showMenuDetails(snapshot.data![index]),
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
                      'Menus in Cart: $menuCounter',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedMenus.length,
                        itemBuilder: (context, index) {
                          final menu = selectedMenus[index];
                          return ListTile(
                            leading: menu['image_url'] != null
                                ? Image.network(
                                    'http://127.0.0.1:8000${menu['image_url']}',
                                    height: 100,
                                    width: 100,
                                  )
                                : Text('No Image'),
                            title: Text(menu['name'], style: TextStyle(color: Colors.white)),
                            subtitle: Text('${menu['price']} dinars', style: TextStyle(color: Colors.white)),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Total: \$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 24, color: Colors.red),
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

class MenuCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onView;
  final VoidCallback onAddToCart;

  const MenuCard({
    required this.item,
    required this.onView,
    required this.onAddToCart,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 42, 42, 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: item['image_url'] != null
                ? Image.network(
                    'http://127.0.0.1:8000${item['image_url']}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Container(
                    color: const Color.fromARGB(255, 47, 46, 46),
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              item['name'],
              style: TextStyle(fontSize: 16, color: Colors.white),
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              '${item['price']} dinars',
              style: TextStyle(fontSize: 14, color: Colors.white),
              maxLines: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.info, color: Colors.blue),
                onPressed: onView,
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.green),
                onPressed: onAddToCart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
