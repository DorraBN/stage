import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import 'package:restaurent/acceuil/screens/home/components/about.dart';
import 'package:restaurent/acceuil/screens/home/components/menus.dart';
import 'package:restaurent/acceuil/screens/home/components/product.dart';
import 'package:restaurent/acceuil/screens/home/components/services_card.dart';
import 'package:restaurent/acceuil/screens/home/components/email_banner.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import 'package:restaurent/acceuil/screens/home/menu/menupage.dart';

import '../../../constants.dart' as my_constants; 

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
            width: double.infinity, // Make sure the container takes the full width available
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuPage()),
                    );
                  },
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.event),
                    label: Text('Reserve a table'),
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



 
class RestaurantMenuPage extends StatelessWidget {
  final List<Menu> menus = [
    Menu(
      title: 'Entrées',
      items: [
        MenuItem(name: 'Salade César', image: 'assets/images/menu-6.png', price: 10.0),
        MenuItem(name: 'Soupe à l\'oignon', image: 'assets/images/menu-6.png', price: 8.0),
        MenuItem(name: 'Bruschetta', image: 'assets/images/menu-6.png', price: 9.0),
      ],
    ),
    Menu(
      title: 'Plats Principaux',
      items: [
        MenuItem(name: 'Steak Frites', image: 'assets/images/menu-6.png', price: 20.0),
        MenuItem(name: 'Poulet Rôti', image: 'assets/images/menu-6.png', price: 18.0),
        MenuItem(name: 'Pâtes Carbonara', image: 'assets/images/menu-6.png', price: 15.0),
      ],
    ),
    Menu(
      title: 'Desserts',
      items: [
        MenuItem(name: 'Tarte Tatin', image: 'assets/images/menu-6.png', price: 7.0),
        MenuItem(name: 'Crème Brûlée', image: 'assets/images/menu-6.png', price: 6.0),
        MenuItem(name: 'Mousse au Chocolat', image: 'assets/images/menu-6.png', price: 5.0),
      ],
    ),
    Menu(
      title: 'Boissons',
      items: [
        MenuItem(name: 'Café', image: 'assets/images/menu-6.png', price: 3.0),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu du Restaurant'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
         
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hero-slider-2.jpg'), 
            fit: BoxFit.cover, 
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
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
                                      
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
             
            ),
          ],
        ),
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
  final double price;

  MenuItem({required this.name, required this.image, required this.price});
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver une Table'),
      ),
      body: Center(
        child: Text('Page de réservation de table'),
      ),
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
}

