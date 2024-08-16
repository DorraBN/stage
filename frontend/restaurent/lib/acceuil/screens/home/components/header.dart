import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import 'package:restaurent/acceuil/screens/home/components/login.dart';
import 'package:restaurent/acceuil/screens/home/components/menu.dart';
import 'package:restaurent/screens/login/login_screen.dart';

import '../../../constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo Home Page'),
        ),
        body: HeaderContainer(),
      ),
    );
  }
}



class BannerSection extends StatelessWidget {
  const BannerSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height, // Adjust height as needed
        width: MediaQuery.of(context).size.width, // Ensure full width
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../../../assets/images/testimonial-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: AboutSection(),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Add other widgets here if necessary
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobBanner extends StatefulWidget {
  const MobBanner({Key? key}) : super(key: key);

  @override
  _MobBannerState createState() => _MobBannerState();
}

class _MobBannerState extends State<MobBanner> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width, // Ensure full width
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../../../assets/images/testimonial-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            AboutSection(),
          ],
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(
          height: 50,
        
        ),
        AutoSizeText(
          "Eat today",
          maxLines: 1,
          style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        
        ),
        AutoSizeText(
          "Live another day",
          maxLines: 1,
          style: TextStyle(
            fontSize: 56,
          ),
        ),
        SizedBox(
          height: 10,
        ),
       
        SizedBox(
          height: 20,
        ),
        Container(
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
          
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                      ),
                      child: Text(
                        'Reserve a table',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              
            
          ],
        ),
         SizedBox(
          height: 10,
        ),
        AutoSizeText(
          "OR",
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
          
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                      ),
                      child: Text(
                        'order delivery',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              
            
          ],
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Row(
      children: [
        // It displays only on mobile and tab
        if (!Responsive.isDesktop(context))
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
        // Replace the Text widget with an Image widget inside ClipOval
    Padding(
  padding: const EdgeInsets.only(left: 30.0, top: 10.0), // Ajuster les valeurs de padding si nécessaire
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage ()), // Remplacez 'LoginPage' par le nom de votre page de connexion
      );
    },
    child: ClipOval(
      child: Image.asset(
        '../../../assets/images/logo.jpg', // Chemin vers votre image
        height: 60, // Ajuster la hauteur selon vos besoins
        width: 60, // Ajuster la largeur pour que ce soit un cercle parfait
        fit: BoxFit.cover, // Assurez-vous que l'image couvre toute la zone circulaire
      ),
    ),
  ),
),

        Spacer(),
        // Menu
        if (Responsive.isDesktop(context)) HeaderWebMenu(),
        Spacer(),
       _size.width > 400
    ? Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.3), width: 1.5), // Adjust border color and width
            borderRadius: BorderRadius.circular(5), // Optional: add rounded corners
          ),
          child: TextField(
            style: TextStyle(color: Colors.black), // Set text color to black
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey), // Optional: set hint text color
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
      )
    : Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.3), width: 1.5), // Adjust border color and width
          borderRadius: BorderRadius.circular(5), // Optional: add rounded corners
        ),
        child: TextField(
          style: TextStyle(color: Colors.black), // Set text color to black
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey), // Optional: set hint text color
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
          ),
        ),
      ),

        SizedBox(
          width: 10,
        ),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 22,
          ),
        )
      ],
    );
  }
}

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.0), // Adjust outer padding as needed
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0), // Adjust inner padding as needed
            constraints: BoxConstraints(maxWidth: 3000),
            child: Column(
              children: [
                Header(),
                SizedBox(
                  height: 50,
                ),
                Responsive.isDesktop(context) ? BannerSection() : MobBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
