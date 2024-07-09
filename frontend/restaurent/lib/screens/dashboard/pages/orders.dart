import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool showTable = false; // Variable to control visibility of the table

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Management"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart), // Icon for Take Orders
              title: Text('Take Orders'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement action for Take Orders here
                setState(() {
                  showTable = true; // Show the table when Take Orders is clicked
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_turned_in), // Icon for Track Orders
              title: Text('Track Orders'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement action for Track Orders here
              },
            ),
            ListTile(
              leading: Icon(Icons.edit), // Icon for Customize Orders
              title: Text('Customize Orders'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement action for Customize Orders here
              },
            ),
            ListTile(
              leading: Icon(Icons.payment), // Icon for Payments
              title: Text('Payments'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Implement action for Payments here
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Widget for home screen with image and phrase
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  Image.asset(
                    '../../../assets/images/order.jpg', // Replace with your image path
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Padding(
  padding: EdgeInsets.only(left: 120), // Adjust the left margin as needed
  child: Text(
    'Welcome to Order Management',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
)

                ],
              ),
            ),
            // Widget to show the table when Take Orders is clicked
            if (showTable)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Phone',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Plat',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Number',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total Price',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Name')),
                        DataCell(Text('Phone')),
                        DataCell(Text('Plat')),
                        DataCell(Text('Price')),
                        DataCell(Text('Number')),
                        DataCell(Text('Total Price')),
                        DataCell(Text('Action')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('John Doe')),
                        DataCell(Text('123-456-7890')),
                        DataCell(Text('Pizza')),
                        DataCell(Text('\$12.00')),
                        DataCell(Text('2')),
                        DataCell(Text('\$24.00')),
                        DataCell(Row(
                        
                        )),
                      ],
                    ),
                    // Add more DataRow entries as needed
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
