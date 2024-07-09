import 'package:flutter/material.dart';

class TablesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table Management"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UI for table management actions (add, edit, delete)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
             
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: [
               
                DataColumn(label: Text('Table Number')),
                DataColumn(label: Text('Number of Chairs')),
                DataColumn(label: Text('Position')),
                 DataColumn(label: Text('Available')),
                  DataColumn(label: Text('Actions')),
              ],
              rows: [
                DataRow(cells: [
                  
                  DataCell(Text('1')),
                  DataCell(Text('4')),
                  DataCell(Text('Corner')),
                   DataCell(Text('yes')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle edit table action for table 1
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle delete table action for table 1
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  )),
                ]),
                DataRow(cells: [
                 
                  DataCell(Text('2')),
                  DataCell(Text('2')),
                  DataCell(Text('Window')),
                   DataCell(Text('yes')),
                   DataCell(Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle edit table action for table 2
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle delete table action for table 2
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  )),
                ]),
                // Add more DataRow entries as needed for each table
              ],
            ),
          ),
        
           
        ],
      )
      
    
    );
  }
}
