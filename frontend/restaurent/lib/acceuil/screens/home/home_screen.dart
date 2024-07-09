import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/constants.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import 'package:restaurent/acceuil/screens/home/components/food.dart';
import 'package:restaurent/acceuil/screens/home/components/footer.dart';
import 'package:restaurent/acceuil/screens/home/components/header.dart';
import 'package:restaurent/acceuil/screens/home/components/menus.dart';
import 'package:restaurent/acceuil/screens/home/menu/meals.dart';
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