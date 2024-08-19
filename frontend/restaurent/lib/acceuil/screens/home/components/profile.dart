
import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/home_screen.dart';
import 'package:restaurent/screens/home/home_screen.dart';class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple, 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('../../assets/b4.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 10),
                  Text('Home'),
                ],
              ),
              onTap: () {
          
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
              onTap: () {
         
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings), 
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
              onTap: () {
              
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout), 
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
              onTap: () {
             
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is where the profile content goes...',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}