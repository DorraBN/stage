import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/components/reservation.dart';

class ReservationForm extends StatefulWidget {
  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _phone = '';
  String _person = '1 Person';
  DateTime _reservationDate = DateTime.now();
  String _time = '08:00am';
  String _message = '';

  List<String> _personOptions = [
    '1 Person',
    '2 Person',
    '3 Person',
    '4 Person',
    '5 Person',
    '6 Person',
    '7 Person'
  ];

  List<String> _timeOptions = [
    '08:00am',
    '09:00am',
    '10:00am',
    '11:00am',
    '12:00pm',
    '01:00pm',
    '02:00pm',
    '03:00pm',
    '04:00pm',
    '05:00pm',
    '06:00pm',
    '07:00pm',
    '08:00pm',
    '09:00pm',
    '10:00pm'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0), // Adjust horizontal padding
      child: Card(
        margin: EdgeInsets.all(20), // Adjust margin as needed
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('../../../assets/images/shape-5.png'), // Path to your PNG image
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(70),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Online Reservation',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Booking request +88-123-123456 or fill out the order form',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10), // Reduced height
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.person), // Icon added here
                            ),
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.phone), // Icon added here
                            ),
                            onChanged: (value) {
                              setState(() {
                                _phone = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Reduced height
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Number of Persons',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.person_outline), // Icon added here
                            ),
                            value: _person,
                            items: _personOptions.map((String person) {
                              return DropdownMenuItem<String>(
                                value: person,
                                child: Text(person),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _person = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Reservation Date',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.calendar_today), // Icon added here
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _reservationDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null && pickedDate != _reservationDate) {
                                setState(() {
                                  _reservationDate = pickedDate;
                                });
                              }
                            },
                            controller: TextEditingController(
                              text: _reservationDate.toLocal().toString().split(' ')[0],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Reservation Time',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.access_time), // Icon added here
                            ),
                            value: _time,
                            items: _timeOptions.map((String time) {
                              return DropdownMenuItem<String>(
                                value: time,
                                child: Text(time),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _time = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Reduced height
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.message), // Icon added here
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _message = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10), // Reduced height
                  FractionallySizedBox(
                    widthFactor: 0.4, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18.0),
                      ),
                      child: Text(
                        'Reserve a table',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        image: DecorationImage(
          image: AssetImage("../../../assets/images/footer-bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 25.0, // Adjust as needed for positioning from the top
            left: -10.0, // Adjust as needed for horizontal positioning
            child: Transform.rotate(
              angle: -0.2, // Adjust the tilt angle here
              child: Image.asset(
                "../../../assets/images/shape-9.png", // Adjust the path accordingly
                height: 170.0, // Adjust the size of the image as needed
                width: 170.0,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foodie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Your ultimate dining experience',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SocialIcon(icon: 'assets/icons/google-icon.svg'),
                      SizedBox(width: 10.0),
                      SocialIcon(icon: 'assets/icons/facebook-2.svg'),
                      SizedBox(width: 10.0),
                      SocialIcon(icon: 'assets/icons/twitter.svg'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact us:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        ContactInfoRow(
                          icon: Icons.email,
                          text: 'contact@foodie.com',
                        ),
                        ContactInfoRow(
                          icon: Icons.phone,
                          text: '+123 456 789',
                        ),
                        SizedBox(height: 10.0),
                        LocationInfoRow(
                          icon: Icons.location_on,
                          text: '123 Restaurant St, Foodie City',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Appetizers',
                          onPressed: () {
                            // Action to perform when clicking on "Appetizers"
                          },
                        ),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Main Course',
                          onPressed: () {
                            // Action to perform when clicking on "Main Course"
                          },
                        ),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Desserts',
                          onPressed: () {
                            // Action to perform when clicking on "Desserts"
                          },
                        ),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Drinks',
                          onPressed: () {
                            // Action to perform when clicking on "Drinks"
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        LocationInfoRow(
                          icon: Icons.location_on,
                          text: '123 Restaurant St, Foodie City',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text('Reserve a table'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class LocationInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const LocationInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(width: 5.0),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class MenuLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const MenuLink({required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(width: 8.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(width: 5.0),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}


