import 'package:flutter/material.dart';

void main() {
  runApp(CardApp());
}

class CardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example data for SmallCards
    List<SmallCardData> cardsData = [
      SmallCardData(title: "Reservations", value: "10", icon: Icons.calendar_today),
      SmallCardData(title: "Orders", value: "5", icon: Icons.shopping_bag),
      SmallCardData(title: "Customers", value: "20", icon: Icons.people),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Card'), // Title of the page
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Scroll horizontally
            itemCount: cardsData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SmallCard(
                  title: cardsData[index].title,
                  value: cardsData[index].value,
                  icon: cardsData[index].icon,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SmallCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 24, color: Colors.blue), // Small icon size
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Small font size
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 10), // Small font size
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Example data model for SmallCards
class SmallCardData {
  final String title;
  final String value;
  final IconData icon;

  SmallCardData({
    required this.title,
    required this.value,
    required this.icon,
  });
}
