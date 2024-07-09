import 'package:flutter/material.dart';

// Model to represent a dish, drink, or supplement
class MenuItem {
  String name;
  String category;
  String description;
  double price;
  bool available;
  String imageUrl; // Added image URL

  MenuItem({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.available = true,
    required this.imageUrl,
  });
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // List of dishes, drinks, and supplements
  List<MenuItem> _menuItems = [
    MenuItem(
      name: 'Caesar Salad',
      category: 'Appetizers',
      description: 'Green salad with grilled chicken, parmesan, and Caesar dressing.',
      price: 12.99,
      available: true,
      imageUrl: '../../../assets/images/about-banner.jpg', // Example local image path
    ),
    MenuItem(
      name: 'Pasta Carbonara',
      category: 'Main Courses',
      description: 'Pasta with carbonara sauce, bacon, and parmesan.',
      price: 15.99,
      available: true,
      imageUrl: '../../../assets/images/about-banner.jpg', // Example local image path
    ),
    MenuItem(
      name: 'Tiramisu',
      category: 'Desserts',
      description: 'Classic Italian dessert with mascarpone and coffee.',
      price: 8.99,
      available: false,
      imageUrl: '../../../assets/images/about-banner.jpg', // Example local image path
    ),

  ];

  List<String> _categories = ['Appetizers', 'Main Courses', 'Desserts', 'Drinks'];

  String _selectedCategory = 'Appetizers'; // Default selected category

  void _addMenuItem(MenuItem item) {
    setState(() {
      _menuItems.add(item);
    });
  }

  void _editMenuItem(int index, MenuItem item) {
    setState(() {
      _menuItems[index] = item;
    });
  }

  void _deleteMenuItem(int index) {
    setState(() {
      _menuItems.removeAt(index);
    });
  }

  void _showMenuItemDialog({MenuItem? item, int? index}) {
    final _nameController = TextEditingController(text: item?.name);
    final _descriptionController = TextEditingController(text: item?.description);
    final _priceController = TextEditingController(text: item?.price.toString());
    final _availableController = TextEditingController(text: item?.available.toString());
    final _imageUrlController = TextEditingController(text: item?.imageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
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
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _availableController,
                  decoration: InputDecoration(labelText: 'Available (true/false)'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _priceController.text.isNotEmpty &&
                    _availableController.text.isNotEmpty &&
                    _imageUrlController.text.isNotEmpty) {
                  final newItem = MenuItem(
                    name: _nameController.text,
                    category: _selectedCategory,
                    description: _descriptionController.text,
                    price: double.parse(_priceController.text),
                    available: _availableController.text.toLowerCase() == 'true',
                    imageUrl: _imageUrlController.text,
                  );

                  if (item == null) {
                    _addMenuItem(newItem);
                  } else {
                    _editMenuItem(index!, newItem);
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
            DataColumn(label: Text('Actions')),
          ],
          rows: _menuItems
              .map((item) => DataRow(cells: [
                    DataCell(Image.asset(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )),
                    DataCell(Text(item.name)),
                    DataCell(Text(item.category)),
                    DataCell(Text(item.description)),
                    DataCell(Text('${item.price} €')),
                    DataCell(Text(item.available ? 'Yes' : 'No')),
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
