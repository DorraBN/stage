import 'package:flutter/material.dart';
import 'package:restaurent/core/constants/color_constants.dart';

class RestaurantInfo {
  final DateTime createDate;
  final int totalReservations;
  final int totalDelivery;

  RestaurantInfo({
    required this.createDate,
    required this.totalDelivery,
    required this.totalReservations,
  });
}

class RecentDiscussions extends StatelessWidget {
  const RecentDiscussions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RestaurantInfo> restaurants = [
      RestaurantInfo(
        createDate: DateTime(2023, 1, 15),
        totalReservations: 50,
        totalDelivery: 50,
      ),
      RestaurantInfo(
        createDate: DateTime(2023, 1, 15),
        totalReservations: 50,
        totalDelivery: 50,
      ),
      // Add more restaurants here
    ];

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Recent Statics",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Text("Restaurant"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Total reservations"),
                ),
                DataColumn(
                  label: Text("Total Delivery"),
                ),
              ],
              rows: List.generate(
                restaurants.length,
                (index) => restaurantDataRow(context, restaurants[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow restaurantDataRow(BuildContext context, RestaurantInfo restaurantInfo) {
  return DataRow(
    cells: [
      DataCell(Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.2),
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text("Restaurant Name"), // Placeholder for restaurant name
      )),
      DataCell(Text(restaurantInfo.createDate.toString())),
      DataCell(Text(restaurantInfo.totalReservations.toString())),
      DataCell(Text(restaurantInfo.totalDelivery.toString())),
    ],
  );
}
