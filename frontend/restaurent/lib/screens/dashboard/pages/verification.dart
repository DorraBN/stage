import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour utiliser jsonDecode

import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/core/utils/colorful_tag.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';

// API URL (remplacez par l'URL de votre API)
const String apiUrl = 'http://localhost:8000/api/reservations?email=dorra@gmail.com'; 

Future<List<UserReservation>> fetchUserDataByEmail(String email) async {
  final response = await http.get(Uri.parse('$apiUrl?email=$email'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => UserReservation.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load reservations');
  }
}

class UserReservation {
  final String name;
  final String phoneNumber;
  final int numberOfPeople;
  final String reservationDate;
  final String reservationTime;
  final String status;

  UserReservation({
    required this.name,
    required this.phoneNumber,
    required this.numberOfPeople,
    required this.reservationDate,
    required this.reservationTime,
    required this.status,
  });

  // Convert JSON to UserReservation
  factory UserReservation.fromJson(Map<String, dynamic> json) {
    return UserReservation(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      numberOfPeople: json['numberOfPeople'],
      reservationDate: json['reservationDate'],
      reservationTime: json['reservationTime'],
      status: json['status'],
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
                text: reservation.name[0],
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
        DataCell(Text(reservation.numberOfPeople.toString())),
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
                onPressed: () {},
              ),
              SizedBox(width: 6),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // Implement update logic
                },
              ),
              SizedBox(width: 6),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  // Implement delete logic
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
