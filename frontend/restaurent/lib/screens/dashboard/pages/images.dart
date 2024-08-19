import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/screens/dashboard/pages/products.dart';

class ImageUploads extends StatefulWidget {
  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  final _addFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isAvailable = false;
  XFile? _pickedFile;
  String? _imageDataUrl;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        _pickedFile = pickedFile;
        _imageDataUrl = base64Image;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_addFormKey.currentState!.validate() && _imageDataUrl != null) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/productss'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': _nameController.text,
            'description': _descriptionController.text,
            'price': double.parse(_priceController.text),
            'category': _categoryController.text,
            'image': 'data:image/png;base64,$_imageDataUrl',
            'is_available': _isAvailable ? 1 : 0,
          }),
        );

        if (response.statusCode == 200) {
          _showSuccessDialog();  // Show the dialog with product details
        } else {
          _showErrorDialog('Failed to add product');
        }
      } catch (e) {
        _showErrorDialog('An error occurred: $e');
      }
    } else {
      _showErrorDialog('Please select an image and fill in all fields');
    }
  }

void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8), // Espace entre l'icône et le texte
            Text('Success'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name: ${_nameController.text}'),
              SizedBox(height: 8), 
              Text('Description: ${_descriptionController.text}'),
              SizedBox(height: 8), 
              Text('Price: ${_priceController.text}'),
              SizedBox(height: 8),
              Text('Category: ${_categoryController.text}'),
              SizedBox(height: 8),
              Text('Availability: ${_isAvailable ? "Available" : "Not Available"}'),
              SizedBox(height: 8), 
              _buildImage(),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()), 
              );
            },
          ),
        ],
      );
    },
  );
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage() {
    if (_imageDataUrl == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.memory(
        base64Decode(_imageDataUrl!),
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Name'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text('Description'),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Description',
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text('Price'),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Price',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text('Category'),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Category',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Availability'),
                        Switch(
                          value: _isAvailable,
                          onChanged: (value) {
                            setState(() {
                              _isAvailable = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: getImage,
                      child: _buildImage(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
