import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProducts;
  final double totalPrice;

  PaymentPage({required this.selectedProducts, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...selectedProducts.map((product) {
              return Text(
                '${product['name']} - ${product['quantity']} x \$${product['price']}',
                style: TextStyle(fontSize: 18),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
