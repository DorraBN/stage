import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:restaurent/core/constants/color_constants.dart';


class TableItem {
  int id; 
  String name;
  int capacity;
  String position;
  bool availability;
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


class TablesPage extends StatefulWidget {
  @override
  _TablesPageState createState() => _TablesPageState();
}


class _TablesPageState extends State<TablesPage> {
  List<TableItem> _tableItems = []; 
  List<String> _positions = ['corner', 'left', 'right', 'center']; 
  String _selectedPosition = 'corner';

  @override
  void initState() {
    super.initState();
    _fetchTableItems();
  }

  Future<void> _fetchTableItems() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/table'); 
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
            availability: item['availability']  ?? 0, 
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


  Future<void> _saveTableItem(TableItem item) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/storeTable'); 
    try {
      final response = await http.post(
        url,
        body: {
          'name': item.name,
          'capacity': item.capacity.toString(),
          'position': item.position,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newTableItem = TableItem(
          id: responseData['id'], 
          name: item.name,
          capacity: item.capacity,
          position: item.position,
          availability: item.availability,
          createdAt: DateTime.parse(responseData['created_at'] ?? DateTime.now().toString()),
          updatedAt: DateTime.parse(responseData['updated_at'] ?? DateTime.now().toString()),
        );

        setState(() {
          _tableItems.add(newTableItem); 
        });

        print('Item added successfully!');
      } else {
        print('Failed to save item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving item: $e');
    }
  }

  Future<void> _editTableItem(int index, TableItem item) async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/update/${item.id}'); 
      final response = await http.put(
        url,
        body: {
          'name': item.name,
          'capacity': item.capacity.toString(),
          'position': item.position,
          'availability': item.availability ? '1' : '0',
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


  Future<void> _deleteTableItem(int index) async {
    try {
      int id = _tableItems[index].id;
      final String apiUrl = 'http://127.0.0.1:8000/api/destroyTable/$id'; 
      var response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _tableItems.removeAt(index); 
        });
        print('Table ID $id deleted successfully');
      } else {
        print('Failed to delete Table. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting Table: $e');
    }
  }

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
                    id: item?.id ?? 0, 
                    name: _nameController.text,
                    capacity: int.parse(_capacityController.text),
                    position: _positionController.text,
                    availability: _availabilityController.text == '1',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

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
        rows: _tableItems.map((item) => DataRow(cells: [
          DataCell(Text(item.name)),
          DataCell(Text(item.capacity.toString())),
          DataCell(Text(item.position)),
          DataCell(Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: item.availability ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.availability ? 'Available' : 'Not Available',
              style: TextStyle(color: Colors.white),
            ),
          )),
          DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(item.createdAt))),
          DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(item.updatedAt))),
          DataCell(Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () => _showTableItemDialog(item: item, index: _tableItems.indexOf(item)),
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
                              Text("Are you sure you want to delete this item?"),
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
                                      _deleteTableItem(_tableItems.indexOf(item));
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
          )),
        ])).toList(),
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
