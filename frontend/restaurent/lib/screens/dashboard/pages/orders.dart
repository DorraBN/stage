import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Order {
  final int id;
  final String customerName;
  final String phoneNumber;
  final String deliveryAddress;
  final String paymentMethod;
  final double totalPrice;
  final bool isConfirmed;

  Order({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.totalPrice,
    required this.isConfirmed,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customer_name'],
      phoneNumber: json['phone_number'],
      deliveryAddress: json['delivery_address'],
      paymentMethod: json['payment_method'],
      totalPrice: (json['total_price'] is String
          ? double.tryParse(json['total_price']) ?? 0.0
          : (json['total_price'] as num).toDouble()),
      isConfirmed: json['is_confirmed'] == 1,
    );
  }
}

class OrderService {
  final String apiUrl = 'http://127.0.0.1:8000/api/orderss';

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Order.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetails(String id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/orders/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load order details');
    }
  }

Future<void> updateOrder(int id, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse('http://127.0.0.1:8000/api/ordersupdate/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update order');
  }
}

}


class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService().fetchOrders();
  }

  Future<void> _deleteOrder(int id) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/api/deleteOrder/$id'));

    if (response.statusCode == 200) {
      setState(() {
        futureOrders = OrderService().fetchOrders(); // Refresh the list
      });
    } else {
      throw Exception('Failed to delete order');
    }
  }

void _viewOrder(Order order) async {
  try {
    final details = await OrderService().fetchOrderDetails(order.id.toString());
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                Icon(Icons.info, size: 36, color: Colors.blue),
                SizedBox(height: 20),
                Text("Order Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          content: Container(
            width: 360,
            height: 370,
            child: SingleChildScrollView( // Use SingleChildScrollView to avoid overflow issues
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Name: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['customer_name'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Phone: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['phone_number'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_city, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Delivery Address: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['delivery_address'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.money, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Payment Method: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['payment_method'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Card Number: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['card_number'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Expiry Date: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['expiry_date'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "CVV: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['cvv'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.list, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Items: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['items'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Total Price: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['total_price'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.date_range_outlined, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Date: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['created_at'] ?? 'N/A'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.confirmation_number, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Confirmation: ", 
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "${details['is_confirmed'] == 0 ? 'cancelled' : 'confirmed'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    // Handle errors
    print('Error fetching order details: $e');
  }
}



void _updateOrder(Order order) async {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController(text: order.customerName);
  final _phoneNumberController = TextEditingController(text: order.phoneNumber);
  final _deliveryAddressController = TextEditingController(text: order.deliveryAddress);
  final _paymentMethodController = TextEditingController(text: order.paymentMethod);
  final _totalPriceController = TextEditingController(text: order.totalPrice.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update Order ${order.id}'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter a customer name' : null,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
                ),
                TextFormField(
                  controller: _deliveryAddressController,
                  decoration: InputDecoration(labelText: 'Delivery Address'),
                  validator: (value) => value!.isEmpty ? 'Please enter a delivery address' : null,
                ),
                TextFormField(
                  controller: _paymentMethodController,
                  decoration: InputDecoration(labelText: 'Payment Method'),
                  validator: (value) => value!.isEmpty ? 'Please enter a payment method' : null,
                ),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: InputDecoration(labelText: 'Total Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter a total price' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updatedOrder = {
                  'customer_name': _customerNameController.text,
                  'phone_number': _phoneNumberController.text,
                  'delivery_address': _deliveryAddressController.text,
                  'payment_method': _paymentMethodController.text,
                  'total_price': double.parse(_totalPriceController.text),
                  // Assuming other fields are handled similarly
                };

                OrderService().updateOrder(order.id, updatedOrder).then((_) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureOrders = OrderService().fetchOrders(); // Refresh the list
                  });
                }).catchError((e) {
                  print('Error updating order: $e');
                });
              }
            },
            child: Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Commandes'),
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune commande disponible.'));
          } else {
            return DataTable(
              columns: const [
              
                DataColumn(label: Text('Nom du Client')),
                DataColumn(label: Text('Téléphone')),
                DataColumn(label: Text('Adresse de Livraison')),
                DataColumn(label: Text('Méthode de Paiement')),
                DataColumn(label: Text('Prix Total')),
                DataColumn(label: Text('État de la Commande')),
                DataColumn(label: Text('Actions')),
              ],
              rows: snapshot.data!.map((order) {
                return DataRow(
                  cells: [
                 DataCell(Text(order.customerName)),
                    DataCell(Text(order.phoneNumber)),
                    DataCell(Text(order.deliveryAddress)),
                    DataCell(Text(order.paymentMethod)),
                    DataCell(Text('${order.totalPrice.toStringAsFixed(2)} €')),
                    DataCell(Text(order.isConfirmed ? 'Confirmée' : 'Non Confirmée')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility, color: Colors.green),
                            onPressed: () => _viewOrder(order),
                            tooltip: 'View',
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _updateOrder(order),
                            tooltip: 'Update',
                          ),
                          SizedBox(width: 6),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.warning_outlined, size: 36, color: Colors.red),
                                          SizedBox(height: 20),
                                          Text("Confirm Deletion"),
                                        ],
                                      ),
                                    ),
                                    content: Container(
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text("Are you sure you want to delete the order with ID ${order.id}?"),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                icon: Icon(Icons.close, size: 14),
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                label: Text("Cancel"),
                                              ),
                                              SizedBox(width: 20),
                                              ElevatedButton.icon(
                                                icon: Icon(Icons.delete, size: 14),
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                onPressed: () {
                                                  _deleteOrder(order.id);
                                                  Navigator.of(context).pop();
                                                },
                                                label: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
