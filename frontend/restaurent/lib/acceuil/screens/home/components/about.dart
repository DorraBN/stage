import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final double backgroundImageWidth;
  final double backgroundImageHeight;

  AboutUsPage({
    this.imageWidth = 200,
    this.imageHeight = 200,
    this.backgroundImageWidth = 400, 
    this.backgroundImageHeight = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../../../../../assets/images/shape-5.png'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 140.0, right: 180), 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2), 
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            'We are a company dedicated to providing the best services to our clients. '
                            'Our team is composed of passionate and experienced professionals who work '
                            'tirelessly to meet your needs.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 13, 172, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), 
                                ),
                              ),
                              child: Text('Delivery'),
                            ),
                            SizedBox(width: 16), 
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 244, 124, 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), 
                                ),
                              ),
                              child: Text('Reserve'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 50.0),
                    width: backgroundImageWidth,
                    height: backgroundImageHeight,
                    child: Image.asset(
                      'assets/images/event-2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 225,
                    right: 230,
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 50.0),
                      width: imageWidth,
                      height: imageHeight,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/a.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(
      imageWidth: 600,
      imageHeight: 600,
      backgroundImageWidth: 1900,
      backgroundImageHeight: 1900,
    ),
  ));
}
