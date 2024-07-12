import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Modèle de MenuItem
class MenuItem {
  int id; // Ajout de l'ID pour identifier chaque élément du menu
  String name;
  String category;
  String description;
  double price;
  int available; 
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.available = 1, 
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}

// Page MenuPage StatefulWidget
class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

// État _MenuPageState de MenuPage
class _MenuPageState extends State<MenuPage> {
  List<MenuItem> _menuItems = [];
  List<String> _categories = ['Appetizers', 'Main Courses', 'Desserts', 'Drinks'];
  String _selectedCategory = 'Appetizers';
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  // Fonction pour récupérer les éléments du menu depuis l'API
  Future<void> _fetchMenuItems() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/menu');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _menuItems = data.map((item) => MenuItem(
            id: item['id'], // Assurez-vous de récupérer l'ID depuis l'API
            name: item['name'] ?? '',
            category: item['category'] ?? '',
            description: item['description'] ?? '',
            price: double.parse(item['price'] ?? '0'),
            available: item['available'] ?? false ? 1 : 0,
            imageUrl: item['imageUrl'] ?? '',
            createdAt: DateTime.parse(item['createdAt'] ?? DateTime.now().toString()),
            updatedAt: DateTime.parse(item['updatedAt'] ?? DateTime.now().toString()),
          )).toList();
        });
      } else {
        print('Failed to fetch menu items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

  // Fonction pour ajouter un nouvel élément au menu
  void _addMenuItem(MenuItem item) {
    setState(() {
      _menuItems.add(item);
    });
  }

  // Fonction pour éditer un élément existant du menu
  void _editMenuItem(int index, MenuItem item) {
    setState(() {
      _menuItems[index] = item;
    });
  }

  // Fonction pour supprimer un élément du menu
  Future<void> _deleteMenuItem(int index) async {
    try {
      int id = _menuItems[index].id; // Récupérer l'ID de l'élément à supprimer
      final String apiUrl = 'http://127.0.0.1:8000/api/destroy/$id'; // URL de l'API de suppression
      var response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Suppression réussie depuis l'API
        setState(() {
          _menuItems.removeAt(index); // Supprimer l'élément de la liste locale
        });
        print('Menu ID $id supprimé avec succès');
      } else {
        // Gérer les erreurs de suppression si nécessaire
        print('Échec de la suppression du menu. Code d\'erreur: ${response.statusCode}');
      }
    } catch (e) {
      // Gérer les erreurs de connexion ou autres
      print('Erreur lors de la suppression du menu: $e');
    }
  }

  // Fonction pour sauvegarder un nouvel élément ou une édition dans la base de données via l'API
  Future<void> _saveMenuItem(MenuItem item) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/store');
    final response = await http.post(
      url,
      body: {
        'name': item.name,
        'category': item.category,
        'description': item.description,
        'price': item.price.toString(),
        'available': item.available.toString(),
        'imageUrl': item.imageUrl,
      },
    );

    if (response.statusCode == 200) {
      print('Item saved successfully!');
    } else {
      print('Failed to save item: ${response.statusCode}');
    }
  }

  // Fonction pour afficher le dialogue d'ajout ou d'édition d'un élément du menu
  void _showMenuItemDialog({MenuItem? item, int? index}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item?.name);
    final _descriptionController = TextEditingController(text: item?.description);
    final _priceController = TextEditingController(text: item?.price.toString());
    final _imageUrlController = TextEditingController(text: item?.imageUrl);
    String _dialogCategory = item?.category ?? _selectedCategory;
    int _dialogAvailable = item?.available ?? 1;

    void _openImagePicker() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          _imageUrlController.text = pickedFile.path;
        }
      });
    }

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
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _dialogCategory,
                    onChanged: (String? value) {
                      setState(() {
                        _dialogCategory = value!;
                      });
                    },
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
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
                  SizedBox(height: 16),
                  _imageFile == null
                      ? ElevatedButton(
                          onPressed: _openImagePicker,
                          child: Text('Pick an image from gallery'),
                        )
                      : Column(
                          children: [
                            Image.file(
                              _imageFile!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _openImagePicker,
                              child: Text('Change image'),
                            ),
                          ],
                        ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _imageUrlController,
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an image';
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
                  final newItem = MenuItem(
                    id: item?.id ?? 0, // Utilisation de l'ID existant ou 0 pour un nouvel élément
                    name: _nameController.text,
                    category: _dialogCategory,
                    description: _descriptionController.text,
                    price: double.parse(_priceController.text),
                    available: _dialogAvailable,
                    imageUrl: _imageUrlController.text,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  if (item == null) {
                    _addMenuItem(newItem);
                  } else {
                    _editMenuItem(index!, newItem);
                  }

                  _saveMenuItem(newItem); // Sauvegarde de l'élément dans la base de données
                  Navigator.of(context).pop(); // Fermeture de la boîte de dialogue
                }
              },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  // Méthode build de l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Management"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Image')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Available')),
            DataColumn(label: Text('Created At')),
            DataColumn(label: Text('Updated At')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _menuItems
              .map((item) => DataRow(cells: [
                    DataCell(item.imageUrl.isNotEmpty
                        ? Image.file(
                            File(item.imageUrl),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image)),
                    DataCell(Text(item.name)),
                    DataCell(Text(item.category)),
                    DataCell(Text(item.description)),
                    DataCell(Text('${item.price.toStringAsFixed(2)} €')),
                    DataCell(Text(item.available == 1 ? 'Available' : 'Not Available')),
                    DataCell(Text(item.createdAt.toString())),
                    DataCell(Text(item.updatedAt.toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showMenuItemDialog(item: item, index: _menuItems.indexOf(item)),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteMenuItem(_menuItems.indexOf(item)),
                        ),
                      ],
                    )),
                  ]))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMenuItemDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuPage(),
  ));
}
