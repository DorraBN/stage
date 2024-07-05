import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/models/daily_info_model.dart';

import 'package:restaurent/responsive.dart';
import 'package:restaurent/screens/dashboard/components/mini_information_widget.dart';
import 'package:restaurent/screens/forms/input_form.dart';
import 'package:flutter/material.dart';

class MiniInformation extends StatelessWidget {
  const MiniInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new FormMaterial();
                    },
                    fullscreenDialog: true));
              },
              icon: Icon(Icons.add),
              label: Text(
                "Add New",
              ),
            ),
          ],
        ),
       
      ],
    );
  }
}


