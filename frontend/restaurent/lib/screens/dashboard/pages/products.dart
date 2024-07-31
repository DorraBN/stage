import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:restaurent/screens/dashboard/pages/image.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> futureProduct;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  XFile? _pickedFile;
  String? _imageDataUrl;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the image upload page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageUpload()),
              );
            },
          ),
        ],
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
                onPressed: () {
                  _nameController.text = item['name'];
                  _descriptionController.text = item['description'];
                  _priceController.text = item['price'].toString();
                  _categoryController.text = item['category'];
                  // You can add the logic to fetch and display the image here
                },
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

