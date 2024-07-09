import 'package:flutter/material.dart';

class Staff {
  String name;
  String phone;
  String imageUrl;

  Staff({required this.name, required this.phone, required this.imageUrl});
}

class StaffPage extends StatefulWidget {
  @override
  _StaffPageState createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<Staff> _staffList = [
    Staff(name: 'John Doe', phone: '123-456-7890', imageUrl: 'assets/images/staff1.png'),
    Staff(name: 'Jane Smith', phone: '098-765-4321', imageUrl: 'assets/images/staff2.png'),
  ];

  void _addStaff(Staff staff) {
    setState(() {
      _staffList.add(staff);
    });
  }

  void _editStaff(int index, Staff staff) {
    setState(() {
      _staffList[index] = staff;
    });
  }

  void _deleteStaff(int index) {
    setState(() {
      _staffList.removeAt(index);
    });
  }

  void _showStaffDialog({Staff? staff, int? index}) {
    final _nameController = TextEditingController(text: staff?.name);
    final _phoneController = TextEditingController(text: staff?.phone);
    final _imageController = TextEditingController(text: staff?.imageUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(staff == null ? 'Add Staff' : 'Edit Staff'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty &&
                    _imageController.text.isNotEmpty) {
                  final newStaff = Staff(
                    name: _nameController.text,
                    phone: _phoneController.text,
                    imageUrl: _imageController.text,
                  );

                  if (staff == null) {
                    _addStaff(newStaff);
                  } else {
                    _editStaff(index!, newStaff);
                  }

                  Navigator.of(context).pop();
                }
              },
              child: Text(staff == null ? 'Add' : 'Save'),
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
        title: Text("Staff"),
        // Adding a menu icon that toggles the drawer
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: SideMenu(), // Assuming you have a SideMenu widget defined
      body: DataTable(
        columns: [
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Phone')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _staffList
            .map((staff) => DataRow(cells: [
                  DataCell(Image.asset(staff.imageUrl)),
                  DataCell(Text(staff.name)),
                  DataCell(Text(staff.phone)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showStaffDialog(staff: staff, index: _staffList.indexOf(staff)),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteStaff(_staffList.indexOf(staff)),
                      ),
                    ],
                  )),
                ]))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStaffDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}

// Example SideMenu widget (replace with your implementation)
class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Text("Menu"),
            ),
            ListTile(
              title: Text("Dashboard"),
              onTap: () {
                // Handle navigation to dashboard
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text("Orders"),
              onTap: () {
                // Handle navigation to orders
                Navigator.pop(context); // Close the drawer
              },
            ),
            // Add more ListTile items for other menu options
          ],
        ),
      ),
    );
  }
}
