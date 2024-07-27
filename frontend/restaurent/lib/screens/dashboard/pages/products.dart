import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> futureProduct;
  File? _image;

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
      setState(() {
        futureProduct = fetchProduct(); // Refresh the list
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showTableItemDialog({Map<String, dynamic>? item, int? index}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item?['name']);
    final _descriptionController = TextEditingController(text: item?['description']);
    final _priceController = TextEditingController(text: item?['price']?.toString());
    final _categoryController = TextEditingController(text: item?['category']);
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
                  TextButton(
                    onPressed: _pickImage,
                    child: Text(_image == null ? 'Pick Image' : 'Change Image'),
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
                    'is_available': _isAvailableController.text == '1',
                    'created_at': DateTime.now().toIso8601String(),
                    'updated_at': DateTime.now().toIso8601String(),
                  };

                  if (item == null) {
                    _saveTableItem(newItem);
                  } else {
                    _editTableItem(index!, newItem);
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
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/api/productss'),
    );
    request.fields['name'] = item['name'];
    request.fields['description'] = item['description'];
    request.fields['price'] = item['price'].toString();
    request.fields['category'] = item['category'];
    request.fields['is_available'] = item['is_available'].toString();
    
    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final response = await request.send();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: item['image'] != null
                                    ? Image.network(
                                        item['image'],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text(item['name'] ?? '',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(item['category'] ?? ''),
                                    Text('Price: ${item['price']?.toString() ?? ''}'),
                                    Text('Availability: ${item['is_available'] == 1 ? 'Available' : 'Unavailable'}'),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _showTableItemDialog(item: item, index: index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteProduct(item['id'].toString()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showTableItemDialog(),
              icon: Icon(Icons.add),
              label: Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }
}
