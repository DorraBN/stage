import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/components/login.dart';

const double kPadding = 16.0;

class MenuPage1 extends StatefulWidget {
  const MenuPage1({Key? key}) : super(key: key);

  @override
  _MenuPage1State createState() => _MenuPage1State();
}

class _MenuPage1State extends State<MenuPage1> {
  int numberOfDishes = 6; // Initial number of dishes
  double totalPrice = 120.0; // Initial total price

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
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ServiceCard(
                          image: "assets/images/big-sandwich-hamburger.jpg",
                          title: "Fastest Delivery",
                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          context: context,
                        ),
                      ),
                      SizedBox(width: kPadding),
                      Expanded(
                        child: ServiceCard(
                          image: "assets/images/big-sandwich-hamburger.jpg",
                          title: "So Much to Choose From",
                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ServiceCard(
                          image: "assets/images/big-sandwich-hamburger.jpg",
                          title: "Best Offer in Town",
                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          context: context,
                        ),
                      ),
                      SizedBox(width: kPadding),
                      Expanded(
                        child: ServiceCard(
                          image: "assets/images/big-sandwich-hamburger.jpg",
                          title: "Best Offer in Town",
                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ServiceCard(
                          image: "assets/images/big-sandwich-hamburger.jpg",
                          title: "Best Offer in Town",
                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          context: context,
                        ),
                      ),
                      SizedBox(width: kPadding),
                      Expanded(
                        child: ServiceCard(
                          image: "assets/images/big-sandwich-hamburger.jpg",
                          title: "Best Offer in Town",
                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(kPadding),
              color: Colors.green[100], // Light green background for the rectangle
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Dishes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$numberOfDishes', // Display dynamic number of dishes
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}', // Display dynamic total price
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  PaymentMethodButton(
                    method: 'Credit Card',
                    icon: Icons.credit_card,
                  ),
                  SizedBox(height: 10),
                  PaymentMethodButton(
                    method: 'PayPal',
                    icon: Icons.paypal,
                  ),
                  SizedBox(height: 10),
                  PaymentMethodButton(
                    method: 'Cash on Delivery',
                    icon: Icons.monetization_on,
                  ),
                ],
              ),
            ),
          ),
        ],
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image,
                height: 150,
                width: double.infinity, // Ensures the image takes up the full width of the card
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

class PaymentMethodButton extends StatelessWidget {
  final String method;
  final IconData icon;

  const PaymentMethodButton({
    Key? key,
    required this.method,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle payment method selection
      },
      icon: Icon(icon),
      label: Text(method),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, 
        backgroundColor: Colors.blue, // Text color
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MenuPage1()));
}
