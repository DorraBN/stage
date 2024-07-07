import 'package:flutter/material.dart';

import '../../../constants.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // now we make service section attractive and good
    return Wrap(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Services(
          image: "../../../assets/images/delivery_boy.jpg",
          title: "Fastest Delivery",
        ),
        Services(
          image: "../../../assets/images/menu.jpg",
          title: "So Much to Choose From",
        ),
        Services(
          image: "../../../assets/images/offer.jpg",
          title: "Best Offer in Town",
        ),
      ],
    );
  }
}

class Services extends StatelessWidget {
  const Services({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);
  final String image, title;
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      image,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, ",
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
                itemCount: 2, // Adjusted for 3 images per row
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
                  // Action à effectuer lors du clic sur le bouton
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
    required double width, // Added width parameter
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(20),
      width: width, // Set width based on parameter
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
