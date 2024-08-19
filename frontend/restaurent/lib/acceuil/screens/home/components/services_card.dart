import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'package:flutter/material.dart';

const kPadding = 16.0;

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: kPadding,
      runSpacing: kPadding,
      children: [
        Services(
          icon: Icons.delivery_dining,
          title: "Fastest Delivery",
        ),
        Services(
          icon: Icons.menu_book,
          title: "So Much to Choose From",
        ),
        Services(
          icon: Icons.local_offer,
          title: "Best Offer in Town",
        ),
      ],
    );
  }
}

class Services extends StatelessWidget {
  const Services({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.all(kPadding / 2),
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.shade400,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FoodPricePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../../../assets/images/hero-slider-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Delicious Menu',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 239, 238, 238)),
              ),
              SizedBox(height: 40),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2, 
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildMenuItem(
                        imagePath: 'assets/images/menu-${index * 3 + 1}.png',
                        name: 'Item ${(index * 3) + 1}',
                        price: '\$25.50',
                        badge: 'Seasonal',
                        description:
                            'Description for item ${(index * 3) + 1}',
                        width: MediaQuery.of(context).size.width / 3.5,
                      ),
                      buildMenuItem(
                        imagePath: 'assets/images/menu-${index * 3 + 2}.png',
                        name: 'Item ${(index * 3) + 2}',
                        price: '\$40.00',
                        description:
                            'Description for item ${(index * 3) + 2}',
                        width: MediaQuery.of(context).size.width / 3.5,
                      ),
                      buildMenuItem(
                        imagePath: 'assets/images/menu-${index * 3 + 3}.png',
                        name: 'Item ${(index * 3) + 3}',
                        price: '\$10.00',
                        description:
                            'Description for item ${(index * 3) + 3}',
                        width: MediaQuery.of(context).size.width / 3.5,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'During winter daily from 7:00 pm to 9:00 pm',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
              
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 243, 156, 33),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'View All Menu',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            
              
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String imagePath,
    required String name,
    required String price,
    String? badge,
    required String description,
    required double width, 
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(20),
      width: width, 
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          if (badge != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.amber,
              child: Text(
                badge,
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(height: 5),
          Text(
            '\$$price',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
