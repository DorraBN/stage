import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/acceuil/model.dart/product_model.dart';
import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/screens/dashboard/pages/images.dart';
import 'package:restaurent/screens/dashboard/pages/menup.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);
  

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<Map<String, dynamic>>> futureProduct;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  XFile? _pickedFile;
  String? _imageDataUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  Future<List<Map<String, dynamic>>> fetchProduct() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load products');
    }
  }

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
  Future<void> _deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/api/destroy/$id'));

    if (response.statusCode == 200) {
      setState(() {
        futureProduct = fetchProduct(); // Refresh the list
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> _updateProduct(String id) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/menuup/$id'),
      body: json.encode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'category': _categoryController.text,
        'image': _imageDataUrl, // Add image data to the update request
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        futureProduct = fetchProduct(); // Refresh the list
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated successfully')));
    } else {
      throw Exception('Failed to update product');
    }
  }
  Widget _buildImage() {
    return _pickedFile != null
        ? Image.memory(
            base64Decode(_imageDataUrl!),
            width: 100,
            height: 100,
          )
        : Text('No image selected');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageUploads1()),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureProduct,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 44.0, // Increase column spacing
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
            } else {
              return Center(child: Text('No menu found'));
            }
          },
        ),
      ),
    );
  }

  DataRow dataRow(Map<String, dynamic> item, BuildContext context) {
    bool isAvailable = item['available'] == 1;

    return DataRow(
      cells: [
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajouter un padding autour du texte
            child: Text(item['name'] ?? ''),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(2.0), // Ajouter un padding autour de l'image
            child: item['image_url'] != null
                ? Image.network(
                    'http://127.0.0.1:8000${item['image_url']}',
                    height: 200, // Ajuster la hauteur de l'image
                    width: 100, // Ajuster la largeur de l'image
                    fit: BoxFit.cover,
                  )
                : Text('No Image'),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajouter un padding autour du texte
            child: Text(item['description'] ?? ''),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajouter un padding autour du texte
            child: Text('${item['price'] ?? '0.0'}'),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajouter un padding autour du texte
            child: Text(item['category'] ?? ''),
          ),
        ),
      DataCell(
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      item['created_at'] != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['created_at']))
          : '',
    ),
  ),
),
DataCell(
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      item['updated_at'] != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['updated_at']))
          : '',
    ),
  ),
),

        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajouter un padding autour du conteneur
            child: Container(
              width: 100, // Ajuster la largeur
              height: 40, // Ajuster la hauteur
              color: isAvailable ? Colors.green : Colors.red,
              child: Center(
                child: Text(
                  isAvailable ? 'Available' : 'Not Available',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajouter un padding autour de la ligne de boutons
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.green),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Center(
                            child: Column(
                              children: [
                                Text(
                                  item['name'] ?? '',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16),
                                item['image_url'] != null
                                    ? Image.network(
                                        'http://127.0.0.1:8000${item['image_url']}',
                                        height: 200,
                                        width: 300,
                                        fit: BoxFit.cover,
                                      )
                                    : Text('No Image'),
                                SizedBox(height: 16),
                                Text(
                                  'Description: ${item['description'] ?? ''}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price: ${item['price'] ?? '0.0'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Category: ${item['category'] ?? ''}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                    item['created_at'] != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['created_at']))
          : '',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                   item['updated_at'] != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(item['updated_at']))
          : '',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Update Product'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _nameController..text = item['name'] ?? '',
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: _descriptionController..text = item['description'] ?? '',
                                  decoration: InputDecoration(labelText: 'Description'),
                                ),
                                TextField(
                                  controller: _priceController..text = item['price'].toString(),
                                  decoration: InputDecoration(labelText: 'Price'),
                                  keyboardType: TextInputType.number,
                                ),
                                TextField(
                                  controller: _categoryController..text = item['category'] ?? '',
                                  decoration: InputDecoration(labelText: 'Category'),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: getImage,
                                  child: Text('Pick Image'),
                                ),
                                 OutlinedButton(
                          onPressed: getImage,
                          child: _buildImage(),
                        ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _updateProduct(item['id'].toString());
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
                  },
                ),
                SizedBox(width: 16), // Espacement horizontal entre les boutons
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
                          color: secondaryColor,
                          height: 70,
                          child: Column(
                            children: [
                              Text(
                                  "Are you sure you want to delete '${item['name'] ?? ''}'?"),
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
                                    icon: Icon(Icons.delete, size: 14),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      _deleteProduct(item['id'].toString());
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
      ),
    ],
  );
 }}