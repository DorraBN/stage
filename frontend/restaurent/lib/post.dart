import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/core/init/provider_list.dart';

void main() {
  runApp(MyApp());
}

Widget build(BuildContext context) {
  return MultiProvider(
    providers: [...ApplicationProvider.instance.dependItems],
    child: FutureBuilder(
      builder: (context, snapshot) {
        return MyApp();
      },
      future: null,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
        scaffoldBackgroundColor: bgColor,
        primaryColor: greenColor,
        dialogBackgroundColor: secondaryColor,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MyApp1(),
    );
  }
}
class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testimonials'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Image positioned at the top right corner
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "../../../assets/images/b.png",
              width: 100, // Set the desired width
              height: 100, // Set the desired height
            ),
          ),
          // Image positioned at the bottom left corner
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "../../../assets/images/b2.png", // Replace with your new image path
              width: 100, // Set the desired width
              height: 100, // Set the desired height
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: [
                  TestimonialCard(
                    name: 'John Doe',
                    testimonial: 'Excellent experience! The service was impeccable and the quality of the products was top-notch.',
                    imageUrl: "../../../assets/images/testi-avatar.jpg",
                  ),
                  TestimonialCard(
                    name: 'Marie Curie',
                    testimonial: 'I highly recommend this company. Very professional and attentive.',
                    imageUrl: "../../../assets/images/testi-avatar.jpg",
                  ),
                  TestimonialCard(
                    name: 'Peter Martin',
                    testimonial: 'A unique experience, I was very satisfied with the service and the products.',
                    imageUrl: "../../../assets/images/testi-avatar.jpg",
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

class TestimonialCard extends StatelessWidget {
  final String name;
  final String testimonial;
  final String imageUrl;

  TestimonialCard({
    required this.name,
    required this.testimonial,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: 300,
            padding: EdgeInsets.only(
              top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.0), // Leave space for the image
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 28.0),
                Row(
                  children: [
                    Icon(Icons.format_quote, color: Colors.grey),
                    SizedBox(width: 28.0),
                    Expanded( // Ensure the text doesn't overflow
                      child: Text(
                        testimonial,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -30, // Position the image to overlap the top of the card
          left: 0,
          right: 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 40.0, // Increase the image size if needed
          ),
        ),
      ],
    );
  }
}
