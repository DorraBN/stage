import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import 'package:restaurent/acceuil/screens/home/components/menu.dart';

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
            image: AssetImage("../../../assets/images/banner.png"),
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
        Text(
          "Foodie",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
            color: kSecondaryColor,
          ),
        ),
        Spacer(),
        // Menu
        if (Responsive.isDesktop(context)) HeaderWebMenu(),
        Spacer(),
        _size.width > 400
            ? Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5), // Adjust left and right padding
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 5), // Adjust left and right padding
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
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
