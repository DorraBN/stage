import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/constants.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import 'package:restaurent/acceuil/screens/home/components/food.dart';
import 'package:restaurent/acceuil/screens/home/components/footer.dart';
import 'package:restaurent/acceuil/screens/home/components/header.dart';
import 'package:restaurent/acceuil/screens/home/components/menus.dart';
import 'package:restaurent/acceuil/screens/home/components/services_card.dart';

import 'package:restaurent/post.dart';
import 'package:restaurent/screens/login/login_screen.dart';
import 'components/body.dart';
import 'components/menu.dart';

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({Key? key}) : super(key: key);

  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "Parrot Chef",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ),
            MobMenu(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              HeaderContainer(),
             
              BodyContainer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  
                  constraints: BoxConstraints(maxHeight: 530),
                  
                  child: MyApp1(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(0), 
                constraints: BoxConstraints(maxWidth: 750),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Responsive.isDesktop(context) ? ReservationForm() :  ReservationForm1(),
                    SizedBox(height: 20), 
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.white), // Icon
                          SizedBox(width: 10), 
                          Text(
                            'Check Reservations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: Colors.green, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(70), 
                        ),
                        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 80), 
                        elevation: 5, // Shadow
                      ),
                    ),
                  ],
                ),
              ),
               
               SizedBox(height: 80),
                    Responsive.isDesktop(context) ? Footer() :  Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
