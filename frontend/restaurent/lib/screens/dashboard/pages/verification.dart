import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To use jsonDecode

import 'package:restaurent/core/constants/color_constants.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';

// API URL (replace with your API URL)
const String baseUrl = 'http://localhost:8000/api/reservations';

Future<List<UserReservation>> fetchUserDataByEmail(String email) async {
  final Uri apiUrl = Uri.parse(baseUrl).replace(queryParameters: {'email': email});

  print('Fetching data from: $apiUrl'); // Debug print
  print('Email: $email'); // Debug print

  try {
    final response = await http.get(apiUrl);

    print('Response status: ${response.statusCode}'); // Debug print
    print('Response body: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserReservation.fromJson(json)).toList();
    } else {
      print('Failed to load reservations');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<void> deleteReservation(String id) async {
  final response = await http.delete(Uri.parse('http://127.0.0.1:8000/api/deletereserves/$id'));

  if (response.statusCode == 200) {
    // Successfully deleted
  } else {
    throw Exception('Failed to delete reservation');
  }
}

Future<void> updateReservation(UserReservation reservation) async {
  final Uri apiUrl = Uri.parse('http://127.0.0.1:8000/api/updateReserve/${reservation.id}');
  
  try {
    final response = await http.put(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': reservation.name,
        'phone': reservation.phoneNumber,
        'email': reservation.email,
        'person': reservation.numberOfPeople,
        'reservation_date': reservation.reservationDate,
        'time': reservation.reservationTime,
        'message': reservation.message,
        'status': reservation.status,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated
    } else {
      throw Exception('Failed to update reservation');
    }
  } catch (e) {
    print('Error: $e');
  }
}


class UserReservation {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String numberOfPeople;
  final String reservationDate;
  final String reservationTime;
  final String message;
  final String status;

  UserReservation({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.numberOfPeople,
    required this.reservationDate,
    required this.reservationTime,
    required this.message,
    required this.status,
  });

  // Convert JSON to UserReservation
  factory UserReservation.fromJson(Map<String, dynamic> json) {
    return UserReservation(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      phoneNumber: json['phone'] ?? 'Unknown',
      email: json['email'] ?? 'Unknown',
      numberOfPeople: json['person'] ?? '0',
      reservationDate: json['reservation_date'] ?? 'Unknown',
      reservationTime: json['time'] ?? 'Unknown',
      message: json['message'] ?? 'Unknown',
       status: json['status'] ?? 'Unknown',// assuming status is always 'Confirmed' as it's not in JSON
    );
  }
}

class VerificationPage extends StatefulWidget {
  final String email;
  final String name;

  VerificationPage({required this.email, required this.name});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late Future<List<UserReservation>> _reservations;

  @override
  void initState() {
    super.initState();
    _reservations = fetchUserDataByEmail(widget.email);
  }

  void _deleteReservation(int id) async {
    await deleteReservation(id.toString());
    setState(() {
      _reservations = fetchUserDataByEmail(widget.email);
    });
  }

  void _showUpdateReservationDialog(BuildContext context, UserReservation reservation) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: reservation.name);
    final _phoneController = TextEditingController(text: reservation.phoneNumber);
    final _emailController = TextEditingController(text: reservation.email);
    final _peopleController = TextEditingController(text: reservation.numberOfPeople);
    final _dateController = TextEditingController(text: reservation.reservationDate);
    final _timeController = TextEditingController(text: reservation.reservationTime);
    final _messageController = TextEditingController(text: reservation.message);
    final _statusController = TextEditingController(text: reservation.status);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Reservation'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _peopleController,
                    decoration: InputDecoration(labelText: 'Number of People'),
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Reservation Date'),
                  ),
                  TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(labelText: 'Reservation Time'),
                  ),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Message'),
                  ),
                  TextFormField(
                    controller: _statusController,
                    decoration: InputDecoration(labelText: 'Status'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedReservation = UserReservation(
                    id: reservation.id,
                    name: _nameController.text,
                    phoneNumber: _phoneController.text,
                    email: _emailController.text,
                    numberOfPeople: _peopleController.text,
                    reservationDate: _dateController.text,
                    reservationTime: _timeController.text,
                    message: _messageController.text,
                    status: _statusController.text,
                  );

                  updateReservation(updatedReservation).then((_) {
                    setState(() {
                      _reservations = fetchUserDataByEmail(widget.email);
                    });
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    print('Error: $error');
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showReservationDetailsDialog(BuildContext context, UserReservation reservation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reservation Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${reservation.name}'),
                Text('Phone Number: ${reservation.phoneNumber}'),
                Text('Email: ${reservation.email}'),
                Text('Number of People: ${reservation.numberOfPeople}'),
                Text('Reservation Date: ${reservation.reservationDate}'),
                Text('Reservation Time: ${reservation.reservationTime}'),
                Text('Message: ${reservation.message}'),
                Text('Status: ${reservation.status}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 8),
              Text(
                "Hello, ${widget.name} 👋",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(width: 8),
              Text(
                "Recent Reservations",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<UserReservation>>(
              future: _reservations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reservations found.'));
                }

                final reservations = snapshot.data!;

                return SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      horizontalMargin: 0,
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(label: Text("Name Surname")),
                        DataColumn(label: Text("Phone Number")),
                        DataColumn(label: Text("Number of People")),
                        DataColumn(label: Text("Reservation Date")),
                        DataColumn(label: Text("Reservation Time")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Operation")),
                      ],
                      rows: reservations.map((reservation) => _dataRow(reservation, context)).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _dataRow(UserReservation reservation, BuildContext context) {
    Color statusColor;

    switch (reservation.status) {
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
                text: reservation.name.isNotEmpty ? reservation.name[0] : 'N/A',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  reservation.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(reservation.phoneNumber)),
        DataCell(Text(reservation.numberOfPeople)),
        DataCell(Text(reservation.reservationDate)),
        DataCell(Text(reservation.reservationTime)),
        DataCell(Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            reservation.status,
            style: TextStyle(color: Colors.white),
          ),
        )),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.visibility, color: greenColor),
                onPressed: () {
                  _showReservationDetailsDialog(context, reservation);
                },
              ),
              SizedBox(width: 6),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showUpdateReservationDialog(context, reservation);
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
                          height: 70,
                          child: Column(
                            children: [
                              Text(
                                  "Are you sure you want to delete '${reservation.name}'?"),
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
                                      _deleteReservation(reservation.id);
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
}
