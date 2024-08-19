
import 'package:restaurent/acceuil/screens/home/components/login.dart';
import 'package:restaurent/acceuil/screens/home/home_screen.dart';

import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/core/init/provider_list.dart';



import 'package:restaurent/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';




void main() {
  runApp(MyApp());
}

Widget build(BuildContext context) {
  return MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: FutureBuilder(
        builder: (context, snapshot) {
          return MyApp();
        }, future: null,
      ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'restaurent ',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(backgroundColor: bgColor, elevation: 0),
        scaffoldBackgroundColor: bgColor,
        primaryColor: greenColor,
        dialogBackgroundColor: secondaryColor,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home:HomeScreen1(),
    );
  }
}