import 'package:flutter/material.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:restaurent/core/constants/color_constants.dart';

class Reserve extends StatefulWidget {
  const Reserve({Key? key}) : super(key: key);

  @override
  _ReserveState createState() => _ReserveState();
}

class _ReserveState extends State<Reserve> {
  late Future<List<Map<String, dynamic>>> futureReservations;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    futureReservations = fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Reservations"),
      ),
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: futureReservations,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 0,
                              columnSpacing: defaultPadding,
                              columns: [
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Email")),
                                DataColumn(label: Text("Phone Number")),
                                DataColumn(label: Text("Number of People")),
                                DataColumn(label: Text("Reservation Date")),
                                DataColumn(label: Text("Reservation Time")),
                                DataColumn(label: Text("Status")),
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
                  ],
                ),
              ),
            ),
            SizedBox(width: defaultPadding),
            Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 45, 45),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              width: 330, // Fixed width for the calendar container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Calendar",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TableCalendar(
                      focusedDay: _selectedDay,
                      firstDay: DateTime.utc(2020, 01, 01),
                      lastDay: DateTime.utc(2100, 12, 31),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow dataRow(Map<String, dynamic> reservation, BuildContext context) {
  String status = reservation['status']?.toString() ?? 'Confirmed';
  Color statusColor;

  switch (status) {
    case "Confirmed":
      statusColor = Colors.green;
      break;
    case 'Cancelled':
      statusColor = Colors.red;
      break;
    case 'Pending':
      statusColor = Colors.orange;
      break;
    default:
      statusColor = Colors.grey;
  }

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            TextAvatar(
              size: 35,
              backgroundColor: Colors.white,
              textColor: Colors.white,
              fontSize: 14,
              upperCase: true,
              numberLetters: 1,
              shape: Shape.Rectangle,
              text: reservation['name']?.toString() ?? '',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                reservation['name']?.toString() ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(reservation['email']?.toString() ?? '')),
      DataCell(Text(reservation['phone']?.toString() ?? '')),
      DataCell(Text(reservation['person']?.toString() ?? '')),
      DataCell(Text(reservation['reservation_date']?.toString() ?? '')),
      DataCell(Text(reservation['time']?.toString() ?? '')),
      DataCell(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(
          status,
          style: TextStyle(color: Colors.white),
        ),
      )),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.visibility, color: greenColor),
              onPressed: () {},
            ),
            SizedBox(width: 6),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Center(
                        child: Column(
                          children: [
                            Icon(Icons.update, size: 36, color: Colors.blue),
                            SizedBox(height: 20),
                            Text("Update Reservation"),
                          ],
                        ),
                      ),
                      content: Container(
                        color: secondaryColor,
                        height: 200,
                        child: Column(
                          children: [
                            Text(
                                "Update reservation for '${reservation['name'] ?? ''}':"),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "New Reservation Date",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "New Reservation Time",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
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
                                  icon: Icon(Icons.update, size: 14),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () {
                                    // Add your update logic here
                                    Navigator.of(context).pop();
                                  },
                                  label: Text("Update"),
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
                        color: secondaryColor,
                        height: 70,
                        child: Column(
                          children: [
                            Text(
                                "Are you sure want to delete '${reservation['name'] ?? ''}'?"),
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
                                    // Add your delete logic here
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
    ],
  );
}

Future<List<Map<String, dynamic>>> fetchReservations() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/showreserves'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => data as Map<String, dynamic>).toList();
  } else {
    throw Exception('Failed to load reservations');
  }
}
