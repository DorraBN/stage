import 'package:restaurent/core/constants/color_constants.dart';
import 'package:restaurent/core/utils/colorful_tag.dart';
import 'package:restaurent/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
class VerificationPage extends StatelessWidget {
  const VerificationPage({
    Key? key,
  }) : super(key: key);

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
                "Hello, Admin 👋",
                style: Theme.of(context).textTheme.titleLarge,
              ),// Add some space between the icon and the text
              Text(
                "Recent Reservations",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text("Name Surname"),
                  ),
                  DataColumn(
                    label: Text("Phone Number"),
                  ),
                  DataColumn(
                    label: Text("Number of People"),
                  ),
                  DataColumn(
                    label: Text("Reservation Date"),
                  ),
                  DataColumn(
                    label: Text("Reservation Time"),
                  ),
                  DataColumn(
                    label: Text("Status"),
                  ),
                  DataColumn(
                    label: Text("Operation"),
                  ),
                ],
                rows: List.generate(
                  recentUsers.length,
                  (index) => recentUserDataRow(recentUsers[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentUserDataRow(RecentUser userInfo, BuildContext context) {
  Color statusColor;

  switch (userInfo.status) {
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
              text: userInfo.name!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                userInfo.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(userInfo.phoneNumber!)),
      DataCell(Text(userInfo.numberOfPeople.toString())),
      DataCell(Text(userInfo.reservationDate!)),
      DataCell(Text(userInfo.reservationTime!)),
      DataCell(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(
          userInfo.status!,
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
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Center(
                        child: Column(
                          children: [
                            Icon(Icons.update, size: 36, color: Colors.blue),
                            SizedBox(height: 20),
                            Text("Update Reservation"),
                          ],
                        ),
                      ),
                      content: Container(
                        color: secondaryColor,
                        height: 200, // Adjust height as needed
                        child: Column(
                          children: [
                            Text(
                                "Update reservation for '${userInfo.name}':"),
                            SizedBox(height: 16),
                            // Add your update form fields here
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "New Reservation Date",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "New Reservation Time",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
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
                                  icon: Icon(Icons.update, size: 14),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () {
                                    // Add your update logic here
                                    Navigator.of(context).pop();
                                  },
                                  label: Text("Update"),
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
                        color: secondaryColor,
                        height: 70,
                        child: Column(
                          children: [
                            Text(
                                "Are you sure want to delete '${userInfo.name}'?"),
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
                                    // Add your delete logic here
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
