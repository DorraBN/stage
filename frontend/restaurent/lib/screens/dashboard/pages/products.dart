import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> futureProduct;
  html.File? _selectedImage;

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

 Future<void> _saveTableItem(Map<String, dynamic> item) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:8000/api/products'),
  );
  request.fields['name'] = item['name'];
  request.fields['description'] = item['description'];
  request.fields['price'] = item['price'].toString();
  request.fields['category'] = item['category'];
  request.fields['is_available'] = item['is_available'] ? '1' : '0';

  if (_selectedImage != null) {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(_selectedImage!);

    reader.onLoadEnd.listen((_) async {
      final bytes = reader.result as Uint8List;
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: _selectedImage!.name,
      );
      request.files.add(multipartFile);

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          setState(() {
            futureProduct = fetchProduct(); // Refresh the list
            _selectedImage = null; // Reset the selected image
          });
        } else {
          throw Exception('Failed to add product');
        }
      } catch (e) {
        print('Error: $e');
      }
    });
  } else {
    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          futureProduct = fetchProduct(); // Refresh the list
          _selectedImage = null; // Reset the selected image
        });
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

  Future<void> _editTableItem(int index, Map<String, dynamic> item) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://127.0.0.1:8000/api/editproduct/$index'),
    );
    request.fields['name'] = item['name'];
    request.fields['description'] = item['description'];
    request.fields['price'] = item['price'].toString();
    request.fields['category'] = item['category'];
    request.fields['is_available'] = item['is_available'] ? '1' : '0';

    if (_selectedImage != null) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(_selectedImage!);

      reader.onLoadEnd.listen((_) async {
        final bytes = reader.result as Uint8List;
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: _selectedImage!.name,
        );
        request.files.add(multipartFile);

        final response = await request.send();

        if (response.statusCode == 200) {
          setState(() {
            futureProduct = fetchProduct(); // Refresh the list
            _selectedImage = null; // Reset the selected image
          });
        } else {
          throw Exception('Failed to edit product');
        }
      });
    } else {
      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          futureProduct = fetchProduct(); // Refresh the list
          _selectedImage = null; // Reset the selected image
        });
      } else {
        throw Exception('Failed to edit product');
      }
    }
  }

 void _pickImage() {
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  input.onChange.listen((e) {
    final files = input.files;
    if (files!.isEmpty) return;
    setState(() {
      _selectedImage = files[0];
    });
  });
}


  void _showTableItemDialog({Map<String, dynamic>? item, int? index}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item?['name']);
    final _descriptionController = TextEditingController(text: item?['description']);
    final _priceController = TextEditingController(text: item?['price']?.toString());
    final _categoryController = TextEditingController(text: item?['category']);

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
                    child: Text('Select Image'),
                  ),
                  if (_selectedImage != null)
                    Image.network(
                      html.Url.createObjectUrlFromBlob(html.Blob([_selectedImage!.slice(0, _selectedImage!.size)])),
                      height: 100,
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
                    'is_available': true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 16.0,
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
        DataCell(Text(item['name'] ?? '')),
        DataCell(item['image'] != null
            ? Image.network('http://127.0.0.1:8000/storage/${item['image']}', height: 50)
            : Text('No Image')),
        DataCell(Text(item['description'] ?? '')),
        DataCell(Text('${item['price'] ?? '0.0'}')),
        DataCell(Text(item['category'] ?? '')),
        DataCell(Text(item['created_at'] ?? '')),
        DataCell(Text(item['updated_at'] ?? '')),
        DataCell(Text((item['is_available'] == 1) ? 'Available' : 'Not Available')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showTableItemDialog(item: item, index: item['id']),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteProduct(item['id']),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
