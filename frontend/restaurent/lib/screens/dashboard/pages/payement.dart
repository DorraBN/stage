import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments Dashboard"),
      ),
      body: GridView.count(
        crossAxisCount: 3, // Display three cards per row
        padding: EdgeInsets.all(160.0),
        childAspectRatio: 0.8, // Adjusted aspect ratio for smaller cards
        children: [
          _buildDashboardItem(
            icon: Icons.account_circle,
            title: 'Interface utilisateur',
            subtitle: 'Fournir une interface intuitive',
            color: Colors.orange, // Color for the card
          ),
          _buildDashboardItem(
            icon: Icons.payment,
            title: 'Paiements',
            subtitle: 'Accepter différents modes de paiement',
            color: Colors.green, // Color for the card
          ),
          _buildDashboardItem(
            icon: Icons.description,
            title: 'Facturation',
            subtitle: 'Générer des factures détaillées',
            color: Colors.blue, // Color for the card
          ),
          _buildDashboardItem(
            icon: Icons.auto_awesome,
            title: 'Facturation automatique',
            subtitle: 'Générer automatiquement les factures',
            color: Colors.purple, // Color for the card
          ),
          _buildDashboardItem(
            icon: Icons.history,
            title: 'Historique des factures',
            subtitle: 'Consulter et auditer les factures',
            color: Colors.red, // Color for the card
          ),
          _buildDashboardItem(
            icon: Icons.file_download,
            title: 'Exportation',
            subtitle: 'Exporter les factures en PDF, Excel',
            color: Colors.teal, // Color for the card
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: color, // Set the background color of the card
      child: Padding(
        padding: EdgeInsets.all(150.0), // Adjusted padding for the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 76, // Icon size
              color: Colors.white, // Icon color (white for contrast)
            ),
            SizedBox(height: 4), // Reduced height between icon and text
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), // Title style (white for contrast)
            ),
           
          ],
        ),
      ),
    );
  }
}
