import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restaurent/acceuil/screens/home/components/reservation.dart';
class ReservationForm extends StatefulWidget {
  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _phone = '';
  String _email = '';
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
    '7 Person',
    '8 Person',
    'larger party'
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

Future<void> _submitReservation() async {
  final url = Uri.parse('http://127.0.0.1:8000/api/reserves');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': _name,
      'phone': _phone,
      'email': _email,
      'person': _person,
      'reservation_date': _reservationDate.toIso8601String(),
      'time': _time,
      'message': _message,
    }),
  );

  if (response.statusCode == 200) {
    // Réservation réussie
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Center(
            child: Text(
              'Réservation réussie!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('../../../../../assets/images/p4.png',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Votre réservation a été effectuée avec succès.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    // Échec de la réservation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Échec de la réservation')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('../../../assets/images/shape-5.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
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
                  SizedBox(height: 5),
                  Text(
                    'Booking request +88-123-123456 or fill out the order form',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
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
                              prefixIcon: Icon(Icons.person),
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
                              prefixIcon: Icon(Icons.phone),
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
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
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
                              prefixIcon: Icon(Icons.person_outline),
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
                              prefixIcon: Icon(Icons.calendar_today),
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
                              prefixIcon: Icon(Icons.access_time),
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
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.message),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _message = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitReservation();
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







class ReservationForm1 extends StatefulWidget {
  @override
  _ReservationForm1State createState() => _ReservationForm1State();
}

class _ReservationForm1State extends State<ReservationForm1> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _phone = '';
  String _email = '';
  String _person = '1 Person';
  DateTime _reservationDate = DateTime.now();
  String _time = '08:00am';
  String _message = '';

  List<String> _personOptions = [
    '1 Person', '2 Person', '3 Person', '4 Person', '5 Person', '6 Person', '7 Person', '8 Person', 'larger party'
  ];

  List<String> _timeOptions = [
    '08:00am', '09:00am', '10:00am', '11:00am', '12:00pm', '01:00pm', '02:00pm', '03:00pm', '04:00pm', '05:00pm', '06:00pm', '07:00pm', '08:00pm', '09:00pm', '10:00pm'
  ];

  Future<void> _submitReservation() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/reserves');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _name,
        'phone': _phone,
        'email': _email,
        'person': _person,
        'reservation_date': _reservationDate.toIso8601String(),
        'time': _time,
        'message': _message,
      }),
    );

    if (response.statusCode == 200) {
      // Réservation réussie
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20),
            title: Center(
              child: Text(
                'Réservation réussie!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/p4.png', 
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Votre réservation a été effectuée avec succès.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Échec de la réservation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la réservation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shape-5.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
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
                  SizedBox(height: 5),
                  Text(
                    'Booking request +88-123-123456 or fill out the order form',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
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
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth > 600 ? 10 : 0), // Responsive spacing
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.phone),
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
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
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
                              prefixIcon: Icon(Icons.person_outline),
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
                      SizedBox(width: screenWidth > 600 ? 10 : 0), 
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Reservation Date',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.calendar_today),
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
                      SizedBox(width: screenWidth > 600 ? 10 : 0),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Reservation Time',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              prefixIcon: Icon(Icons.access_time),
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
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.message),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _message = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitReservation,
                    child: Text('Submit Reservation'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
            top: 25.0,
            left: -10.0, 
            child: Transform.rotate(
              angle: -0.2,
              child: Image.asset(
                "../../../assets/images/shape-9.png",
                height: 170.0, 
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
                        'Parrot Chef',
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
                           
                          },
                        ),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Main Course',
                          onPressed: () {
                           
                          },
                        ),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Desserts',
                          onPressed: () {
                           
                          },
                        ),
                        MenuLink(
                          icon: Icons.restaurant_menu,
                          title: 'Drinks',
                          onPressed: () {
                            
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




