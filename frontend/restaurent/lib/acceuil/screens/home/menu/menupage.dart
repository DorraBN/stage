import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RestaurantMenuPage(),
    );
  }
}

class RestaurantMenuPage extends StatefulWidget {
  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  late Future<List<Menu>> futureMenus;

  @override
  void initState() {
    super.initState();
    futureMenus = fetchMenus();
  }

  Future<List<Menu>> fetchMenus() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));

    if (response.statusCode == 200) {
      final List<dynamic> menusJson = json.decode(response.body);
      return menusJson.map((json) => Menu.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu du Restaurant'),
      ),
      body: FutureBuilder<List<Menu>>(
        future: futureMenus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final menus = snapshot.data!;
            return ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return ExpansionTile(
                  title: Text(menu.title),
                  children: menu.items.map((item) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.network(
                          'http://127.0.0.1:8000${item.image}', // Update URL
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.name),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          } else {
            return Center(child: Text('No menu found'));
          }
        },
      ),
    );
  }
}

class Menu {
  final String title;
  final List<MenuItem> items;

  Menu({required this.title, required this.items});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      title: json['title'],
      items: (json['items'] as List<dynamic>).map((item) => MenuItem.fromJson(item)).toList(),
    );
  }
}

class MenuItem {
  final String name;
  final String image;

  MenuItem({required this.name, required this.image});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      image: json['image'],
    );
  }
}
