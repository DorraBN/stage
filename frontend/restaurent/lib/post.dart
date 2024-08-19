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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Testimonials', 
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
               
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.star, color: Colors.orange), 
          ],
        ),
       
      ),
      body: Stack(
        children: [
         
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "../../../assets/images/b.png",
              width: 100, 
              height: 100,
            ),
          ),
          
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "../../../assets/images/b2.png",
              width: 100, 
              height: 100, 
            ),
          ),
         
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
                    imageUrl: "../../../assets/images/test2.jpg",
                  ),
                  TestimonialCard(
                    name: 'justin doe',
                    testimonial: 'I highly recommend this company. Very professional and attentive.',
                    imageUrl: "../../../assets/images/testi-avatar.jpg",
                  ),
                  TestimonialCard(
                    name: 'Peter Martin',
                    testimonial: 'A unique experience, I was very satisfied with the service and the products.',
                    imageUrl: "../../../assets/images/test1.jpg",
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

class TestimonialCard extends StatefulWidget {
  final String name;
  final String testimonial;
  final String imageUrl;

  TestimonialCard({
    required this.name,
    required this.testimonial,
    required this.imageUrl,
  });

  @override
  _TestimonialCardState createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
  
        double cardWidth = constraints.maxWidth > 600 ? 350 : 250; 

        return MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
              _controller.forward();
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
              _controller.reverse();
            });
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      width: cardWidth, 
                      padding: EdgeInsets.only(
                        top: 60.0, left: 16.0, right: 16.0, bottom: 16.0), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.0),
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.deepOrange,
                            ),
                          ),
                          SizedBox(height: 28.0),
                          Row(
                            children: [
                              Icon(Icons.format_quote, color: Colors.grey),
                              SizedBox(width: 28.0),
                              Expanded(
                                child: Text(
                                  widget.testimonial,
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
                    top: -40, 
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 50.0, 
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          width: 100.0, 
                          height: 100.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}