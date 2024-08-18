import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:restaurent/acceuil/screens/home/components/buy.dart';
import 'package:restaurent/acceuil/screens/home/components/footer.dart';

class MenuPage2 extends StatefulWidget {
  const MenuPage2({Key? key}) : super(key: key);

  @override
  _MenuPage2State createState() => _MenuPage2State();
}

class _MenuPage2State extends State<MenuPage2> {
  late Future<List<Map<String, dynamic>>> futureMenu;
  List<Map<String, dynamic>> displayedMenus = [];
  List<Map<String, dynamic>> selectedMenus = [];
  String selectedCategory = 'All';
  int menuCounter = 0;

  // Définir des catégories statiques avec des images associées
  final List<Map<String, String>> categories = [
    {'name': 'All', 'icon': 'Icons.list'},
    {'name': 'Appetizers', 'image': '../../../assets/images/Appetizers.webp'},
    {'name': 'Main Course', 'image': '../../../assets/images/main.webp'},
    {'name': 'Desserts', 'image': '../../../assets/images/dessert.webp'},
    {'name': 'Drinks', 'image': '../../../assets/images/drinks.webp'},
  ];

  @override
  void initState() {
    super.initState();
    futureMenu = fetchMenu();
  }

  Future<List<Map<String, dynamic>>> fetchMenu() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));

    if (response.statusCode == 200) {
      final List<dynamic> menusJson = json.decode(response.body);
      List<Map<String, dynamic>> menus = menusJson.cast<Map<String, dynamic>>();
      return menus;
    } else {
      throw Exception('Failed to load menus');
    }
  }

  void filterMenusByCategory(String category) {
    setState(() {
      selectedCategory = category;
      futureMenu.then((menus) {
        if (category == 'All') {
          displayedMenus = menus;
        } else {
          displayedMenus = menus.where((menu) => menu['category'] == category).toList();
        }
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Menu"),
      actions: [
        Container(
          margin: EdgeInsets.all(8.0),
          child: TextButton.icon(
            onPressed: () {
              // Action à définir pour le bouton Track Orders
            },
            icon: Icon(Icons.track_changes, color: Colors.white),
            label: Text("Track Orders", style: TextStyle(color: Colors.white)),
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
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: futureMenu,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          displayedMenus = selectedCategory == 'All' ? snapshot.data! : displayedMenus;
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Section de gauche
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0), // Padding en haut
                            child: Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: selectedCategory == categories[index]['name']
                                      ? Colors.orange
                                      : Colors.white,
                                  child: ListTile(
                                    leading: categories[index]['name'] == 'All'
                                        ? Icon(Icons.list, size: 30)
                                        : Image.asset(
                                            categories[index]['image']!,
                                            width: 30,
                                            height: 30,
                                          ),
                                    title: Text(categories[index]['name']!),
                                    onTap: () {
                                      filterMenusByCategory(categories[index]['name']!);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0), // Padding en bas
                            child: ElevatedButton.icon(
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
                                  fontSize: 14, // Taille de police augmentée
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(150, 50),
                                backgroundColor: Colors.orange, // Couleur de fond
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Coins légèrement arrondis
                                ),
                                elevation: 5, // Effet d'ombre
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section de droite
                    Expanded(
                      flex: 2,
                      child: GridView.builder(
                        padding: EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: displayedMenus.length,
                        itemBuilder: (context, index) {
                          return MenuCard(
                            item: displayedMenus[index],
                            onView: () => _showMenuDetails(displayedMenus[index]),
                            onAddToCart: () => _addToCart(displayedMenus[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    ),
  );
}


  void _showMenuDetails(Map<String, dynamic> menu) async {
    // Méthode pour afficher les détails du menu (comme vous l'avez implémentée)
  }

  void _addToCart(Map<String, dynamic> menu) {
    setState(() {
      selectedMenus.add(menu);
      menuCounter++;
    });
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPage3()), // Navigation vers MenuPage3
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
