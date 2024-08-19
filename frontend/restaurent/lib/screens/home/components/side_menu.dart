import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/components/login.dart';
import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/screens/dashboard/components/recent_users%20copy.dart';
import 'package:restaurent/screens/dashboard/pages/menu.dart';
import 'package:restaurent/screens/dashboard/pages/orders.dart';
import 'package:restaurent/screens/dashboard/pages/payement.dart';
import 'package:restaurent/screens/dashboard/pages/products.dart';
import 'package:restaurent/screens/dashboard/pages/reserve.dart';

import 'package:restaurent/screens/dashboard/pages/tables.dart';
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Restaurant App"),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            if (_scaffoldKey.currentState!.isDrawerOpen) {
              _scaffoldKey.currentState!.openEndDrawer();
            } else {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
      
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultPadding * 3,
                ),
               ClipOval(
  child: Image.asset(
    "../../../.././assets/images/logo.jpg",
    scale: 5,
    width: 50, 
    height: 50,
  ),
)
,
                SizedBox(
                  height: 10,
                ),
                Text("Restaurant")
              ],
            )),
            DrawerListTile(
              title: "Home",
              icon: Icons.dashboard,
               press: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );},
            ),
            DrawerListTile(
              title: "Orders",
              icon: Icons.receipt_long,
              press: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage()),
              );},
            ),
            DrawerListTile(
              title: "Tables",
              icon: Icons.table_chart,
              press: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TablesPage()),
              );},
            ),
            DrawerListTile(
              title: "Reservation",
              icon: Icons.event,
               press: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reserve()),
              );},
            ),
            DrawerListTile(
              title: "Menu",
              icon: Icons.restaurant_menu,
              press: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );},
            ),
          
              DrawerListTile(
              title: "products",
              icon: Icons.food_bank,
              press: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );},
            ),
            DrawerListTile(
              title: "Payments",
              icon: Icons.payment,
              press: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentsPage()),
              );
              },
            ),
               DrawerListTile(
              title: "Reports",
              icon: Icons.analytics,
              press: () {},
            ), 
            
            DrawerListTile(
              title: "Settings",
              icon: Icons.settings,
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: Colors.white54,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
