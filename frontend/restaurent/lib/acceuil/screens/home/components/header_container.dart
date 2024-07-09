// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/model.dart/responsive.dart';
import '../../../constants.dart';

import 'header.dart';

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(50),
            constraints: BoxConstraints(maxWidth: kMaxWidth),
            child: Column(
              children: [
                Header(),
                SizedBox(
                  height: 10,
                ),
                Responsive.isDesktop(context) ? BannerSection() : MobBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}