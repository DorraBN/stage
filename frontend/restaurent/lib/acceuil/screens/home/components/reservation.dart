import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            constraints: BoxConstraints(maxWidth: 600.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ReservationForm(),
          ),
        ),
      ),
    );
  }
}

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
    return Form(
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
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Number of Persons',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Reservation Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Reservation Time',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
            ],
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _message = value;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
          
              }
            },
            child: Text('Book A Table'),
          ),
        ],
      ),
    );
  }
}
class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Foodie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
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
    );
  }
}

class SocialIcon extends StatelessWidget {
  final String icon;

  const SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        icon,
        height: 20.0,
        width: 20.0,
      ),
    );
  }
}
