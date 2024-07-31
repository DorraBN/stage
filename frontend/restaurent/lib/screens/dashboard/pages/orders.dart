import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class Order {
  final int id;
  final String customerName;
  final String phoneNumber;
  final String deliveryAddress;
  final String paymentMethod;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final double totalPrice;
  final bool isConfirmed;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    required this.createdAt,
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
      createdAt: DateTime.parse(json['created_at']),
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
  final _cardNumberController = TextEditingController(text: order.cardNumber ?? '');
  final _expiryDateController = TextEditingController(text: order.expiryDate ?? '');
  final _cvvController = TextEditingController(text: order.cvv ?? '');
  final _totalPriceController = TextEditingController(text: order.totalPrice.toString());
  bool _isConfirmed = order.isConfirmed;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Column(
            children: [
              Icon(Icons.update, size: 36, color: Colors.blue),
              SizedBox(height: 20),
              Text("Update Order"),
            ],
          ),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                TextFormField(
                  controller: _deliveryAddressController,
                  decoration: InputDecoration(labelText: 'Delivery Address'),
                ),
                TextFormField(
                  controller: _paymentMethodController,
                  decoration: InputDecoration(labelText: 'Payment Method'),
                ),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: InputDecoration(labelText: 'Total Price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Confirmed'),
                  value: _isConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _isConfirmed = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
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
                icon: Icon(Icons.update, size: 14),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedOrder = {
                      'customer_name': _customerNameController.text,
                      'phone_number': _phoneNumberController.text,
                      'delivery_address': _deliveryAddressController.text,
                      'payment_method': _paymentMethodController.text,
                      'card_number': _cardNumberController.text,
                      'expiry_date': _expiryDateController.text,
                      'cvv': _cvvController.text,
                      'total_price': double.tryParse(_totalPriceController.text) ?? 0.0,
                      'is_confirmed': _isConfirmed ? 1 : 0,
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
                label: Text("Update"),
              ),
            ],
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
        title: Text('Order List'),
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders available.'));
          } else {
            return DataTable(
              columns: const [
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Delivery Address')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Payment Method')),
                DataColumn(label: Text('Total Price')),
                DataColumn(label: Text('Order Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: snapshot.data!.map((order) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          TextAvatar(
                            size: 35,
                            backgroundColor: Colors.white,
                            textColor: Colors.white,
                            fontSize: 14,
                            upperCase: true,
                            numberLetters: 1,
                            shape: Shape.Rectangle,
                            text: order.customerName,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              order.customerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(order.phoneNumber)),
                    DataCell(Text(order.deliveryAddress)),
                    DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(order.createdAt))),
                    DataCell(Text(order.paymentMethod)),
                    DataCell(Text('${order.totalPrice.toStringAsFixed(2)} dinars')),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {}, // Add functionality if needed
                        style: ElevatedButton.styleFrom(
                          backgroundColor: order.isConfirmed ? Colors.green : Colors.red,
                          minimumSize: Size(100, 36), // Adjust size as needed
                        ),
                        child: Text(
                          order.isConfirmed ? 'Confirmed' : 'Cancelled',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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