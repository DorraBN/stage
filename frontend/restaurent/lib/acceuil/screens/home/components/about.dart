import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos de nous'),
      ),
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../../../assets/images/box_cover_gold.png'), // Remplacez par le chemin de votre image de fond
                
              ),
            ),
          ),
          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À propos de nous',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ajustez la couleur du texte pour qu'elle soit visible sur l'image de fond
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nous sommes une entreprise dédiée à fournir les meilleurs services à nos clients. '
                        'Notre équipe est composée de professionnels passionnés et expérimentés qui travaillent '
                        'sans relâche pour répondre à vos besoins.',
                        style: TextStyle(fontSize: 16, color: Colors.white), // Ajustez la couleur du texte pour qu'elle soit visible sur l'image de fond
                      ),
                    ],
                  
                ),
               
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(),
  ));
}
