import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/core/widgets/app_button_widget.dart';
import 'package:restaurent/core/widgets/input_widget.dart';
import 'package:restaurent/screens/dashboard/pages/verification.dart';
import 'dart:convert';

import 'package:restaurent/screens/home/home_screen.dart';
import 'package:restaurent/screens/login/components/slider_widget.dart';


class Login1 extends StatefulWidget {
  @override
  _Login1State createState() => _Login1State();
}

class _Login1State extends State<Login1> with SingleTickerProviderStateMixin {
  var tweenLeft = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  var tweenRight = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
      .chain(CurveTween(curve: Curves.ease));

  AnimationController? _animationController;

  var _isMoved = false;
  String _email = ''; 
  String _name = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<bool> _checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/check-email'), 
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['exists']; 
    } else {
      throw Exception('Failed to check email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.white,
                child: SliderWidget(),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
                color: bgColor,
                child: Center(
                  child: Card(
                    color: bgColor,
                    child: Container(
                      padding: EdgeInsets.all(22),
                      width: MediaQuery.of(context).size.width / 3.6,
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          ClipOval(
                            child: Image.asset(
                              "../../assets/images/logo.jpg",
                              scale: 3,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 24.0),
                          Flexible(
                            child: _registerScreen(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _registerScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 0.0,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputWidget(
              keyboardType: TextInputType.text,
              onSaved: (String? value) {
                _name = value ?? '';
              },
              onChanged: (String? value) {
                _name = value ?? '';
              },
              validator: (String? value) {
                return value != null && value.isEmpty ? 'Name cannot be empty' : null;
              },
              topLabel: "Name",
              hintText: "Enter Name",
            ),
          
            SizedBox(height: 8.0),
            InputWidget(
              topLabel: "Tel",
              obscureText: true,
              hintText: "Enter Tel",
              onSaved: (String? uPassword) {},
              onChanged: (String? value) {},
              validator: (String? value) {},
            ),
            SizedBox(height: 24.0),
          AppButton(
  type: ButtonType.PRIMARY,
  text: "Check your reservations",
  onPressed: () async {
    if (_email.isEmpty) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    try {
      final exists = await _checkEmailExists(_email);
      if (exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(email: _email, name:_name),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Reservation'),
              content: Text(
                'Hello, $_name! You have not made any reservation. Email: $_email',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); 
                    Navigator.of(context).pop(); 
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  },
),
            SizedBox(height: 24.0),
            Center(
              child: Wrap(
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
