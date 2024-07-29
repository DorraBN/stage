import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final double totalPrice;

  PaymentPage({required this.selectedProducts, required this.totalPrice});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  String? _paymentMethod;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Payment"),
    ),
    body: Row(
      children: [
        // Partie gauche: Image
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey[200], // Couleur de fond pour l'image
            child: Image.asset(
              '../../../../../assets/images/d3.jpg', // Remplacez par le chemin de votre image
              fit: BoxFit.cover,
              width: double.infinity, // Assurez-vous que l'image occupe toute la largeur
              height: double.infinity, // Assurez-vous que l'image occupe toute la hauteur
            ),
          ),
        ),
        // Partie droite: Formulaire avec défilement
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
         children: [
  Row(
    children: [
      Icon(Icons.add_shopping_cart, size: 24,color: Colors.green,), // Icône à gauche du texte
      SizedBox(width: 8), // Espacement entre l'icône et le texte
      Text(
        'Products:',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ],
  ),
  ...widget.selectedProducts.map((product) {
    int quantity = product['quantity'] ?? 1;
    return Row(
      children: [
        Icon(Icons.restaurant_menu, size: 24), // Icône du produit
        SizedBox(width: 8),
        Expanded(
          child: Text(
            '${product['name']} - $quantity x \$${product['price']}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }).toList(),


                    SizedBox(height: 20),
                    Text(
                      
                      'Total Price: ${widget.totalPrice.toStringAsFixed(2)} Dinars',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Delivery Details:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person), // Icône du nom
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone), // Icône du téléphone
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        prefixIcon: Icon(Icons.home), // Icône de l'adresse
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Payment Method:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Credit Card'),
                      leading: Radio<String>(
                        value: 'Credit Card',
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value;
                          });
                        },
                      ),
                      trailing: Icon(Icons.credit_card), // Icône de la carte de crédit
                    ),
                    ListTile(
                      title: const Text('Cash on Delivery'),
                      leading: Radio<String>(
                        value: 'Cash on Delivery',
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value;
                          });
                        },
                      ),
                      trailing: Icon(Icons.money), // Icône de l'argent
                    ),
                    Visibility(
                      visible: _paymentMethod == 'Credit Card',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Credit Card Details:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: _cardNumberController,
                            decoration: InputDecoration(
                              labelText: 'Card Number',
                              prefixIcon: Icon(Icons.credit_card), // Icône du numéro de carte
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter your card number' : null,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _expiryDateController,
                            decoration: InputDecoration(
                              labelText: 'Expiry Date (MM/YY)',
                              prefixIcon: Icon(Icons.date_range), // Icône de la date
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter the expiry date' : null,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              prefixIcon: Icon(Icons.lock), // Icône du CVV
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter the CVV' : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true && _paymentMethod != null) {
                            _showConfirmationDialog(context);
                          }
                        },
                        child: Text('Confirm Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Couleur de fond orange
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Coins arrondis
                          ),
                        ),
                      ),
                    ),
         ]
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Column(
            children: [
              Icon(Icons.warning_outlined, size: 36, color: Colors.red),
              SizedBox(height: 30),
              Text("Confirm Order"),
            ],
          ),
        ),
        content: Container(
          color: Color.fromARGB(255, 53, 52, 52),
          height: 80,
          child: Column(
            children: [
              Text("Are you sure you want to confirm the order?"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.close, size: 14),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: Text("Cancel"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.check, size: 14),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fermer la boîte de dialogue de confirmation
                      _showCongratulationsDialog(context); // Afficher la boîte de dialogue de félicitations
                    },
                    label: Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Column(
            children: [
              Icon(Icons.check_circle, size: 36, color: Colors.green),
              SizedBox(height: 20),
              Text("Congratulations!"),
            ],
          ),
        ),
        content: Container(
          color: const Color.fromARGB(255, 60, 60, 60),
          height: 70,
          child: Column(
            children: [
              Text("Your order has been successfully placed."),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue de félicitations
                  _showExportOptionsDialog(context); // Afficher la boîte de dialogue d'exportation
                },
                child: Text("OK"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Column(
            children: [
              Icon(Icons.file_download, size: 36, color: Colors.blue),
              SizedBox(height: 20),
              Text("Export Invoice"),
            ],
          ),
        ),
        content: Container(
          color: const Color.fromARGB(255, 60, 60, 60),
          height: 70,
          child: Column(
            children: [
              Text("Would you like to export the invoice?"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.picture_as_pdf, size: 14),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _exportAsPdf();
                    },
                    label: Text("PDF"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.table_chart, size: 14),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _exportAsExcel();
                    },
                    label: Text("Excel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportAsPdf() {
    // Implémentez ici votre logique d'exportation en PDF
    print('Export as PDF');
  }

  void _exportAsExcel() {
    // Implémentez ici votre logique d'exportation en Excel
    print('Export as Excel');
  }
}
