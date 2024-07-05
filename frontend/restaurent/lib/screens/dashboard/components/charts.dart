import 'package:restaurent/core/constants/color_constants.dart'; // Remplacez par le chemin correct
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class DailyInfoModel {
  IconData? icon;
  String? title;
  String? totalStorage;
  int? volumeData;
  int? percentage;
  Color? color;
  List<Color>? colors;
  List<FlSpot>? spots;

  DailyInfoModel({
    this.icon,
    this.title,
    this.totalStorage,
    this.volumeData,
    this.percentage,
    this.color,
    this.colors,
    this.spots,
  });

  DailyInfoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    volumeData = json['volumeData'];
    icon = getIconData(json['icon']); // Appel de la fonction pour récupérer IconData
    totalStorage = json['totalStorage'];
    color = json['color'] is Color
        ? json['color']
        : Color(json['color']); // Correction pour récupérer la couleur correctement
    percentage = json['percentage'];
    colors = (json['colors'] as List<dynamic>?)?.map((color) => Color(color)).toList(); // Correction pour convertir la liste de couleurs
    spots = (json['spots'] as List<dynamic>?)?.map((spot) => FlSpot(spot['x'].toDouble(), spot['y'].toDouble())).toList(); // Correction pour convertir la liste de FlSpot
  }

  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'user_alt_faw5s':
        return Icons.people;
      case 'message1_ant':
        return Icons.message_outlined;
      case 'comment_alt_faw5s':
        return Icons.comment_outlined;
      case 'heart_faw5s':
        return Icons.favorite_outlined;
      case 'bell_faw5s':
        return Icons.notifications_outlined;
      default:
        return Icons.error_outline;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['volumeData'] = this.volumeData;
    data['icon'] = this.icon != null ? getIconName(this.icon!) : null; // Conversion de IconData en nom d'icône
    data['totalStorage'] = this.totalStorage;
    data['color'] = this.color != null ? this.color!.value : null; // Conversion de Color en valeur hexadécimale
    data['percentage'] = this.percentage;
    data['colors'] = this.colors?.map((color) => color.value).toList(); // Conversion de la liste de couleurs en valeurs hexadécimales
    data['spots'] = this.spots?.map((spot) => {'x': spot.x, 'y': spot.y}).toList(); // Conversion de la liste de FlSpot en Map
    return data;
  }

  String getIconName(IconData iconData) {
    // Fonction inverse pour récupérer le nom de l'icône à partir de IconData
    if (iconData == Icons.people) return 'user_alt_faw5s';
    if (iconData == Icons.message_outlined) return 'message1_ant';
    if (iconData == Icons.comment_outlined) return 'comment_alt_faw5s';
    if (iconData == Icons.favorite_outlined) return 'heart_faw5s';
    if (iconData == Icons.notifications_outlined) return 'bell_faw5s';
    return '';
  }
}

List<DailyInfoModel> dailyDatas =
    dailyData.map((item) => DailyInfoModel.fromJson(item)).toList();

var dailyData = [
  {
    "title": "Employee",
    "volumeData": 1328,
    "icon": 'user_alt_faw5s', // Utilisation du nom d'icône au lieu de FlutterIcons
    "totalStorage": "+ %20",
    "color": primaryColor.value, // Utilisation de la valeur hexadécimale de la couleur
    "percentage": 35,
    "colors": [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ],
    "spots": [
      {'x': 1.0, 'y': 2.0},
      {'x': 2.0, 'y': 1.0},
      {'x': 3.0, 'y': 1.8},
      {'x': 4.0, 'y': 1.5},
      {'x': 5.0, 'y': 1.0},
      {'x': 6.0, 'y': 2.2},
      {'x': 7.0, 'y': 1.8},
      {'x': 8.0, 'y': 1.5},
    ]
  },
  {
    "title": "On Leave",
    "volumeData": 1328,
    "icon": 'message1_ant', // Utilisation du nom d'icône au lieu de FlutterIcons
    "totalStorage": "+ %5",
    "color": Color(0xFFFFA113).value, // Utilisation de la valeur hexadécimale de la couleur
    "percentage": 35,
    "colors": [Color(0xfff12711), Color(0xfff5af19)],
    "spots": [
      {'x': 1.0, 'y': 1.3},
      {'x': 2.0, 'y': 1.0},
      {'x': 3.0, 'y': 4.0},
      {'x': 4.0, 'y': 1.5},
      {'x': 5.0, 'y': 1.0},
      {'x': 6.0, 'y': 3.0},
      {'x': 7.0, 'y': 1.8},
      {'x': 8.0, 'y': 1.5},
    ]
  },
  {
    "title": "Onboarding",
    "volumeData": 1328,
    "icon": 'comment_alt_faw5s', // Utilisation du nom d'icône au lieu de FlutterIcons
    "totalStorage": "+ %8",
    "color": Color(0xFFA4CDFF).value, // Utilisation de la valeur hexadécimale de la couleur
    "percentage": 10,
    "colors": [Color(0xff2980B9), Color(0xff6DD5FA)],
    "spots": [
      {'x': 1.0, 'y': 1.3},
      {'x': 2.0, 'y': 5.0},
      {'x': 3.0, 'y': 1.8},
      {'x': 4.0, 'y': 6.0},
      {'x': 5.0, 'y': 1.0},
      {'x': 6.0, 'y': 2.2},
      {'x': 7.0, 'y': 1.8},
      {'x': 8.0, 'y': 1.0},
    ]
  },
  {
    "title": "Open Position",
    "volumeData": 1328,
    "icon": 'heart_faw5s', // Utilisation du nom d'icône au lieu de FlutterIcons
    "totalStorage": "+ %8",
    "color": Color(0xFFd50000).value, // Utilisation de la valeur hexadécimale de la couleur
    "percentage": 10,
    "colors": [Color(0xff93291E), Color(0xffED213A)],
    "spots": [
      {'x': 1.0, 'y': 3.0},
      {'x': 2.0, 'y': 4.0},
      {'x': 3.0, 'y': 1.8},
      {'x': 4.0, 'y': 1.5},
      {'x': 5.0, 'y': 1.0},
      {'x': 6.0, 'y': 2.2},
      {'x': 7.0, 'y': 1.8},
      {'x': 8.0, 'y': 1.5},
    ]
  },
  {
    "title": "Efficiency",
    "volumeData": 5328,
    "icon": 'bell_faw5s', // Utilisation du nom d'icône au lieu de FlutterIcons
    "totalStorage": "- %5",
    "color": Color(0xFF00F260).value, // Utilisation de la valeur hexadécimale de la couleur
    "percentage": 78,
    "colors": [Color(0xff0575E6), Color(0xff00F260)],
    "spots": [
      {'x': 1.0, 'y': 1.3},
      {'x': 2.0, 'y': 1.0},
      {'x': 3.0, 'y': 1.8},
      {'x': 4.0, 'y': 1.5},
      {'x': 5.0, 'y': 1.0},
      {'x': 6.0, 'y': 2.2},
      {'x': 7.0, 'y': 1.8},
      {'x': 8.0, 'y': 1.5},
    ]
  },
];
