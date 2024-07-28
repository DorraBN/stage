import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:restaurent/core/constants/color_constants.dart'; // Make sure this path is correct

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  Future<List<Map<String, dynamic>>> fetchProduct() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> _deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/api/deleteproducts/$id'));

    if (response.statusCode == 200) {
      // Successfully deleted
      setState(() {
        futureProduct = fetchProduct(); // Refresh the list
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }

  Future<Map<String, dynamic>> _fetchProductDetails(String id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/productdetails/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load product details');
    }
  }

  void _showTableItemDialog({Map<String, dynamic>? item, int? index}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item?['name']);
    final _descriptionController = TextEditingController(text: item?['description']);
    final _priceController = TextEditingController(text: item?['price']?.toString());
    final _categoryController = TextEditingController(text: item?['category']);
    final _imageController = TextEditingController(text: item?['image']);
    final _isAvailableController = TextEditingController(text: item?['is_available']?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      if (value.length > 255) {
                        return 'Name cannot exceed 255 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value != null && value.length > 1000) {
                        return 'Description cannot exceed 1000 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the category';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value != null && !Uri.tryParse(value)!.hasAbsolutePath == true) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _isAvailableController,
                    decoration: InputDecoration(labelText: 'Availability (1 for available, 0 for unavailable)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the availability';
                      }
                      if (value != '0' && value != '1') {
                        return 'Availability must be 0 or 1';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newItem = {
                    'id': item?['id'] ?? 0,
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'price': double.parse(_priceController.text),
                    'category': _categoryController.text,
                    'image': _imageController.text,
                    'is_available': _isAvailableController.text == '1',
                    'created_at': DateTime.now().toIso8601String(),
                    'updated_at': DateTime.now().toIso8601String(),
                  };

                  if (item == null) {
                    _saveTableItem(newItem); // Implement this method
                  } else {
                    _editTableItem(index!, newItem); // Implement this method
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTableItem(Map<String, dynamic> item) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/productss'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureProduct = fetchProduct(); // Refresh the list
      });
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<void> _editTableItem(int index, Map<String, dynamic> item) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/editproduct/$index'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureProduct = fetchProduct(); // Refresh the list
      });
    } else {
      throw Exception('Failed to edit product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: futureProduct,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 0,
                              columnSpacing: defaultPadding,
                              columns: [
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Image")),
                                DataColumn(label: Text("Description")),
                                DataColumn(label: Text("Price")),
                                DataColumn(label: Text("Category")),
                                DataColumn(label: Text("Created At")),
                                DataColumn(label: Text("Updated At")),
                                DataColumn(label: Text("Availability")),
                                DataColumn(label: Text("Operation")),
                              ],
                              rows: List.generate(
                                snapshot.data!.length,
                                (index) => dataRow(snapshot.data![index], context),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTableItemDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  DataRow dataRow(Map<String, dynamic> item, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text(item['name'])),
        DataCell(
          item['image'] != null
              ? Image.network(
                  item['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Text('No Image'),
        ),
        DataCell(Text(item['description'])),
        DataCell(Text(item['price'].toString())),
        DataCell(Text(item['category'])),
        DataCell(Text(item['created_at'])),
        DataCell(Text(item['updated_at'])),
        DataCell(Text(item['is_available'] == 1 ? 'Available' : 'Unavailable')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showTableItemDialog(item: item),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteProduct(item['id'].toString()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
