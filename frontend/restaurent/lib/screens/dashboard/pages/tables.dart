import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Modèle de TableItem
class TableItem {
  int id; // Ajout de l'ID pour identifier chaque élément de la Table
  String name;
  int capacity;
  String position;
  bool availability; // Utilisation de bool pour l'indicateur d'availability
  DateTime createdAt;
  DateTime updatedAt;

  TableItem({
    required this.id,
    required this.name,
    required this.capacity,
    required this.position,
    required this.availability,
    required this.createdAt,
    required this.updatedAt,
  });
}

// Page TablesPage StatefulWidget
class TablesPage extends StatefulWidget {
  @override
  _TablesPageState createState() => _TablesPageState();
}

// État _TablesPageState de TablesPage
class _TablesPageState extends State<TablesPage> {
  List<TableItem> _tableItems = []; // Renommage en _tableItems
  List<String> _positions = ['corner', 'left', 'right', 'center']; // Correction du typo 'right'
  String _selectedPosition = 'corner';

  @override
  void initState() {
    super.initState();
    _fetchTableItems();
  }

  // Fonction pour récupérer les éléments de la Table depuis l'API
  Future<void> _fetchTableItems() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/table'); // Correction du nom de l'API
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _tableItems = data.map((item) => TableItem(
            id: item['id'],
            name: item['name'] ?? '',
            capacity: item['capacity'] ?? 0,
            position: item['position'] ?? '',
            availability: item['availability'] == 1, // Conversion en booléen
            createdAt: DateTime.parse(item['created_at'] ?? DateTime.now().toString()),
            updatedAt: DateTime.parse(item['updated_at'] ?? DateTime.now().toString()),
          )).toList();
        });
      } else {
        print('Failed to fetch Table items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Table items: $e');
    }
  }

  // Fonction pour ajouter un nouvel élément à la Table via l'API
  Future<void> _saveTableItem(TableItem item) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/storeTable'); // Endpoint de sauvegarde
    try {
      final response = await http.post(
        url,
        body: {
          'name': item.name,
          'capacity': item.capacity.toString(),
          'position': item.position,
          'availability': item.availability ? '1' : '0', // Conversion en entier pour l'API
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newTableItem = TableItem(
          id: responseData['id'], // Assurez-vous que votre API retourne l'ID nouvellement créé
          name: item.name,
          capacity: item.capacity,
          position: item.position,
          availability: item.availability,
          createdAt: DateTime.parse(responseData['created_at'] ?? DateTime.now().toString()),
          updatedAt: DateTime.parse(responseData['updated_at'] ?? DateTime.now().toString()),
        );

        setState(() {
          _tableItems.add(newTableItem); // Ajoutez à la liste locale
        });

        print('Item added successfully!');
      } else {
        print('Failed to save item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving item: $e');
    }
  }

  // Fonction pour éditer un élément existant de la Table via l'API
  Future<void> _editTableItem(int index, TableItem item) async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/update/${item.id}'); // Endpoint de mise à jour
      final response = await http.put(
        url,
        body: {
          'name': item.name,
          'capacity': item.capacity.toString(),
          'position': item.position,
          'availability': item.availability ? '1' : '0', // Conversion en entier pour l'API
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _tableItems[index] = item;
        });
        print('Item updated successfully!');
      } else {
        print('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  // Fonction pour supprimer un élément de la Table via l'API
  Future<void> _deleteTableItem(int index) async {
    try {
      int id = _tableItems[index].id;
      final String apiUrl = 'http://127.0.0.1:8000/api/destroyTable/$id'; // Endpoint de suppression
      var response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _tableItems.removeAt(index); // Supprimer localement l'élément supprimé
        });
        print('Table ID $id deleted successfully');
      } else {
        print('Failed to delete Table. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting Table: $e');
    }
  }

  // Fonction pour afficher le dialogue d'ajout ou d'édition d'un élément de la Table
  void _showTableItemDialog({TableItem? item, int? index}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: item?.name);
    final _capacityController = TextEditingController(text: item?.capacity.toString());
    final _positionController = TextEditingController(text: item?.position);
    final _availabilityController = TextEditingController(text: item?.availability.toString());

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
                  TextFormField(
                    controller: _capacityController,
                    decoration: InputDecoration(labelText: 'Capacity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the capacity';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _positionController,
                    decoration: InputDecoration(labelText: 'Position'),
                  ),
                  TextFormField(
                    controller: _availabilityController,
                    decoration: InputDecoration(labelText: 'Availability'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the availability';
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
                  final newItem = TableItem(
                    id: item?.id ?? 0, // Utilisation de l'ID existant ou 0 pour un nouvel élément
                    name: _nameController.text,
                    capacity: int.parse(_capacityController.text),
                    position: _positionController.text,
                    availability: _availabilityController.text == '1', // Conversion en booléen
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  if (item == null) {
                    _saveTableItem(newItem); // Appel de la fonction de sauvegarde pour nouvel élément
                  } else {
                    _editTableItem(index!, newItem); // Appel de la fonction d'édition
                  }

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
        title: Text("Table Management"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Capacity')),
            DataColumn(label: Text('Position')),
            DataColumn(label: Text('Availability')),
            DataColumn(label: Text('Created At')),
            DataColumn(label: Text('Updated At')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _tableItems
              .map((item) => DataRow(cells: [
                    DataCell(Text(item.name)),
                    DataCell(Text(item.capacity.toString())),
                    DataCell(Text(item.position)),
                    DataCell(Text(item.availability ? 'Available' : 'Not Available')),
                    DataCell(Text(item.createdAt.toString())),
                    DataCell(Text(item.updatedAt.toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showTableItemDialog(item: item, index: _tableItems.indexOf(item)),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTableItem(_tableItems.indexOf(item)),
                        ),
                      ],
                    )),
                  ]))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTableItemDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TablesPage(),
  ));
}
