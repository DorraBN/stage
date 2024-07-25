import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final double backgroundImageWidth;
  final double backgroundImageHeight;

  AboutUsPage({
    this.imageWidth = 200,
    this.imageHeight = 200,
    this.backgroundImageWidth = 400, // Valeurs par défaut pour l'image d'arrière-plan
    this.backgroundImageHeight = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../../../../../assets/images/shape-5.png'), // Image d'arrière-plan
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte à gauche avec marges
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 140.0, right: 180), // Adjusted padding
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Background color with opacity
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      border: Border.all(color: Colors.white, width: 2), // Border color and width
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 32, // Taille de police plus grande pour le titre
                              fontWeight: FontWeight.bold, // Texte en gras
                              color: Colors.white, // Couleur du texte
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            'Nous sommes une entreprise dédiée à fournir les meilleurs services à nos clients. '
                            'Notre équipe est composée de professionnels passionnés et expérimentés qui travaillent '
                            'sans relâche pour répondre à vos besoins.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Texte en blanc
                              height: 1.5, // Interligne
                            ),
                          ),
                        ),
                        SizedBox(height: 16), // Espacement entre le texte et les boutons
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Action pour le bouton "Delivery"
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 172, 130, 13), // Couleur orange
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Square border
                                ),
                              ),
                              child: Text('Delivery'),
                            ),
                            SizedBox(width: 16), // Espacement entre les boutons
                            ElevatedButton(
                              onPressed: () {
                                // Action pour le bouton "Reserve"
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 244, 124, 5), // Couleur orange
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Square border
                                ),
                              ),
                              child: Text('Reserve'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Images à droite
              Stack(
                children: [
                  // Image d'arrière-plan avec marges
                  Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 50.0), // Marges autour de l'image d'arrière-plan
                    width: backgroundImageWidth,
                    height: backgroundImageHeight,
                    child: Image.asset(
                      'assets/images/event-2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 225,
                    right: 230,
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 50.0),
                      width: imageWidth,
                      height: imageHeight,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/a.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsPage(
      imageWidth: 600,
      imageHeight: 600,
      backgroundImageWidth: 1900,
      backgroundImageHeight: 1900,
    ),
  ));
}

