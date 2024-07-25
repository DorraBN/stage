import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/core/widgets/app_button_widget.dart';
import 'package:restaurent/core/widgets/input_widget.dart';
import 'package:restaurent/screens/dashboard/pages/verification.dart';

import 'package:restaurent/screens/home/home_screen.dart';
import 'package:restaurent/screens/login/components/slider_widget.dart';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  var tweenLeft = Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  var tweenRight = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
      .chain(CurveTween(curve: Curves.ease));

  AnimationController? _animationController;

  var _isMoved = false;

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
    width: 100, // Ajustez la largeur selon vos besoins
    height: 100, // Ajustez la hauteur selon vos besoins
    fit: BoxFit.cover, // Ajuste l'image pour couvrir tout le cercle
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
              keyboardType: TextInputType.emailAddress,
              onSaved: (String? value) {},
              onChanged: (String? value) {},
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
              topLabel: "Name",
              hintText: "Enter Name",
            ),
            SizedBox(height: 8.0),
            InputWidget(
              keyboardType: TextInputType.emailAddress,
              onSaved: (String? value) {},
              onChanged: (String? value) {},
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
              topLabel: "Email",
              hintText: "Enter E-mail",
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerificationPage()),
                );
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
