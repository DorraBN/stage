import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent/core/constants/color_constants.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // Create a global key to uniquely identify the Scaffold
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
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultPadding * 3,
                ),
                Image.asset(
                  "assets/logo/logo_icon.png",
                  scale: 5,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text("Restaurant")
              ],
            )),
            DrawerListTile(
              title: "Dashboard",
              icon: Icons.dashboard,
              press: () {},
            ),
            DrawerListTile(
              title: "Orders",
              icon: Icons.receipt_long,
              press: () {},
            ),
            DrawerListTile(
              title: "Tables",
              icon: Icons.table_chart,
              press: () {},
            ),
            DrawerListTile(
              title: "Categories",
              icon: Icons.category,
              press: () {},
            ),
            DrawerListTile(
              title: "Menu",
              icon: Icons.restaurant_menu,
              press: () {},
            ),
            DrawerListTile(
              title: "Staff",
              icon: Icons.people,
              press: () {},
            ),
            DrawerListTile(
              title: "Payments",
              icon: Icons.payment,
              press: () {},
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
