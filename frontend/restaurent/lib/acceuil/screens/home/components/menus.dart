import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/components/login.dart';

const double kPadding = 16.0;

class MenuPage extends StatelessWidget {
  const MenuPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          spacing: kPadding,
          runSpacing: kPadding,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20, left: 90),
              child: ServiceCard(
                image: "assets/images/big-sandwich-hamburger.jpg",
                title: "Fastest Delivery",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                context: context,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: ServiceCard(
                image: "assets/images/big-sandwich-hamburger.jpg",
                title: "So Much to Choose From",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                context: context,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: ServiceCard(
                image: "assets/images/big-sandwich-hamburger.jpg",
                title: "Best Offer in Town",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                context: context,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 90),
              child: ServiceCard(
                image: "assets/images/big-sandwich-hamburger.jpg",
                title: "Best Offer in Town",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                context: context,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: ServiceCard(
                image: "assets/images/big-sandwich-hamburger.jpg",
                title: "Best Offer in Town",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                context: context,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: ServiceCard(
                image: "assets/images/big-sandwich-hamburger.jpg",
                title: "Best Offer in Town",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final BuildContext context;

  const ServiceCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.context,
  }) : super(key: key);

  void addToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image,
                height: 250,
                width: 280,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: addToCart,
              icon: Icon(Icons.shopping_cart),
              label: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}



void main() {
  runApp(MaterialApp(home: MenuPage()));
}
