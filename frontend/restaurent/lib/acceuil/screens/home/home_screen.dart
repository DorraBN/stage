import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/constants.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import 'package:restaurent/acceuil/screens/home/components/food.dart';
import 'package:restaurent/acceuil/screens/home/components/footer.dart';
import 'package:restaurent/acceuil/screens/home/components/header.dart';
import 'package:restaurent/acceuil/screens/home/components/menus.dart';
import 'package:restaurent/acceuil/screens/home/menu/meals.dart';
import 'package:restaurent/screens/login/login_screen.dart';
import 'components/body.dart';
import 'components/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "Foodie",
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
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 490),
                  child: MealsListView(),
                ),
              ),
              BodyContainer(),
              Container(
                padding: EdgeInsets.all(0), // Adjust inner padding as needed
                constraints: BoxConstraints(maxWidth: 750),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Responsive.isDesktop(context) ? ReservationForm() : MobBanner(),
                    SizedBox(height: 20), // Add some spacing between form/banner and button
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
                          SizedBox(width: 10), // Space between icon and text
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
                        backgroundColor: Colors.green, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(70), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 80), // Padding inside the button
                        elevation: 5, // Shadow
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
