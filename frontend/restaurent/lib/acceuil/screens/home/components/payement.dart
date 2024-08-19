import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
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
     
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey[200], 
            child: Image.asset(
              '../../../../../assets/images/d3.jpg', 
              fit: BoxFit.cover,
              width: double.infinity, 
              height: double.infinity, 
            ),
          ),
        ),
     
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
      Icon(Icons.add_shopping_cart, size: 24,color: Colors.green,), 
      SizedBox(width: 8), 
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
        Icon(Icons.restaurant_menu, size: 24), 
        SizedBox(width: 8),
        Expanded(
          child: Text(
            '${product['name']} - $quantity x ${product['price']} dinars',
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
                        prefixIcon: Icon(Icons.person), 
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone), 
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        prefixIcon: Icon(Icons.home), 
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
                      trailing: Icon(Icons.credit_card), 
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
                      trailing: Icon(Icons.money), 
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
                              prefixIcon: Icon(Icons.credit_card), 
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
                              prefixIcon: Icon(Icons.date_range),
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
                              prefixIcon: Icon(Icons.lock), 
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
                          backgroundColor: Colors.orange, 
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
                      Navigator.of(context).pop(); 
                      _showCongratulationsDialog(context); 
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
                Navigator.of(context).pop();
               
                _showExportOptionsDialog(context); 
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
                    label: Text("Print"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


void _exportAsPdf() async {
  final pdf = pw.Document();

  
  final logoImage = pw.MemoryImage(
    (await rootBundle.load('../../../.././assets/images/logo.jpg')).buffer.asUint8List(),
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Stack(
        children: [
       
          pw.Positioned(
            left: 10,
            top: 10,
            right: 10,
            bottom: 10,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue, width: 4),
                borderRadius: pw.BorderRadius.circular(15),
         
              ),
              padding: pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                 
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Image(logoImage, width: 100), 
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Restaurant Delivery Confirmation',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Customer Name: ${_nameController.text}',
                  ),
                  pw.Text(
                    'Phone Number: ${_phoneController.text}',
                  ),
                  pw.Text(
                    'Delivery Address: ${_addressController.text}',
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Order Details:',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: widget.selectedProducts.map((product) {
                      int quantity = product['quantity'] ?? 1;
                      return pw.Text(
                        '${product['name']} - $quantity x ${product['price']} dinars',
                      );
                    }).toList(),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Total Price: ${widget.totalPrice.toStringAsFixed(2)} Dinars',
                    style: pw.TextStyle(color: PdfColors.red),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Payment Method: $_paymentMethod',
                  ),
                  if (_paymentMethod == 'Credit Card') ...[
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'Card Number: ${_cardNumberController.text}',
                    ),
                    pw.Text(
                      'Expiry Date: ${_expiryDateController.text}',
                    ),
                    pw.Text(
                      'CVV: ${_cvvController.text}',
                    ),
                  ],
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Delivery Date: ${DateTime.now()}',
                  ),
                ],
              ),
            ),
          ),
        
          pw.Positioned(
            bottom: 20,
            right: 20,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Restaurant Address: 123 Restaurant St, City, Country',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                  ),
                ),
                pw.Text(
                  'Phone Number: +123 456 7890',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  try {
    final pdfFile = await pdf.save();

  
    await Printing.sharePdf(bytes: pdfFile, filename: 'restaurant_delivery_confirmation.pdf');
  } catch (e) {
    print('Error generating PDF: $e');
  }
}







Future<void> _exportAsExcel() async {
 final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Order Details', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Products:', style: pw.TextStyle(fontSize: 18)),
              ...widget.selectedProducts.map((product) {
                return pw.Row(
                  children: [
                    pw.Text('${product['name']}'),
                    pw.SizedBox(width: 10),
                    pw.Text('Quantity: ${product['quantity']}'),
                    pw.SizedBox(width: 10),
                    pw.Text('Price: ${product['price']}'),
                  ],
                );
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Text('Total Price: ${widget.totalPrice.toStringAsFixed(2)} Dinars', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Delivery Details:', style: pw.TextStyle(fontSize: 18)),
              pw.Text('Name: ${_nameController.text}'),
              pw.Text('Phone: ${_phoneController.text}'),
              pw.Text('Address: ${_addressController.text}'),
              pw.SizedBox(height: 20),
              pw.Text('Payment Method: ${_paymentMethod ?? 'Not Selected'}', style: pw.TextStyle(fontSize: 18)),
              if (_paymentMethod == 'Credit Card') ...[
                pw.Text('Card Number: ${_cardNumberController.text}'),
                pw.Text('Expiry Date: ${_expiryDateController.text}'),
                pw.Text('CVV: ${_cvvController.text}'),
              ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
