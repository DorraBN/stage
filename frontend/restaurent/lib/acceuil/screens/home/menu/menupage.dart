import 'package:flutter/material.dart';

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

class RestaurantMenuPage extends StatelessWidget {
  final List<Menu> menus = [
    Menu(
      title: 'Entrées',
      items: [
        MenuItem(name: 'Salade César', image: '../../../assets/images/d.jpg'),
        MenuItem(name: 'Soupe à l\'oignon', image: 'assets/images/soupe_oignon.jpg'),
        MenuItem(name: 'Bruschetta', image: 'assets/images/bruschetta.jpg'),
      ],
    ),
    Menu(
      title: 'Plats Principaux',
      items: [
        MenuItem(name: 'Steak Frites', image: 'assets/images/steak_frites.jpg'),
        MenuItem(name: 'Poulet Rôti', image: 'assets/images/poulet_roti.jpg'),
        MenuItem(name: 'Pâtes Carbonara', image: 'assets/images/pates_carbonara.jpg'),
      ],
    ),
    Menu(
      title: 'Desserts',
      items: [
        MenuItem(name: 'Tarte Tatin', image: 'assets/images/tarte_tatin.jpg'),
        MenuItem(name: 'Crème Brûlée', image: 'assets/images/creme_brulee.jpg'),
        MenuItem(name: 'Mousse au Chocolat', image: 'assets/images/mousse_chocolat.jpg'),
      ],
    ),
    Menu(
      title: 'Boissons',
      items: [
        MenuItem(name: 'Vin Rouge', image: 'assets/images/vin_rouge.jpg'),
        MenuItem(name: 'Vin Blanc', image: 'assets/images/vin_blanc.jpg'),
        MenuItem(name: 'Café', image: 'assets/images/cafe.jpg'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu du Restaurant'),
      ),
      body: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          return ExpansionTile(
            title: Text(menu.title),
            children: menu.items.map((item) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.asset(
                    item.image,
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
      ),
    );
  }
}

class Menu {
  final String title;
  final List<MenuItem> items;

  Menu({required this.title, required this.items});
}

class MenuItem {
  final String name;
  final String image;

  MenuItem({required this.name, required this.image});
}
