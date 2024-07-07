
import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/home_screen.dart';class ProfilePage extends StatelessWidget {
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
                color: Colors.purple, // Couleur mauve pour l'en-tête du tiroir
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('../../assets/b4.jpg'), // Ajout de l'image de profil
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
                  Icon(Icons.home), // Ajout de l'icône Home
                  SizedBox(width: 10),
                  Text('Home'),
                ],
              ),
              onTap: () {
                // Naviguer vers HomeScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person), // Ajout de l'icône Person
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
              onTap: () {
                // Ajouter la logique de navigation ici
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings), // Ajout de l'icône Settings
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
              onTap: () {
                // Ajouter la logique de navigation ici
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout), // Ajout de l'icône Logout
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
              onTap: () {
                // Ajouter la logique de déconnexion ici
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