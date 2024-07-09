import 'package:flutter/material.dart';
import 'package:restaurent/acceuil/screens/home/menu/fitness_app_theme.dart';

class MealsListView extends StatefulWidget {
  const MealsListView({
    Key? key,
  }) : super(key: key);

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> {
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 216,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
        itemCount: mealsListData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return MealsView(
            mealsListData: mealsListData[index],
          );
        },
      ),
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView({
    Key? key,
    this.mealsListData,
  }) : super(key: key);

  final MealsListData? mealsListData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: HexColor(mealsListData!.endColor).withOpacity(0.6),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0,
                  ),
                ],
                gradient: LinearGradient(
                  colors: <HexColor>[
                    HexColor(mealsListData!.startColor),
                    HexColor(mealsListData!.endColor),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 54, left: 16, right: 16, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      mealsListData!.titleTxt,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: FitnessAppTheme.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                           
                          ],
                        ),
                      ),
                    ),
                    mealsListData?.kacl != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                mealsListData!.kacl.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  letterSpacing: 0.2,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 3),
                                child: Text(
                                  'kcal',
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: FitnessAppTheme.nearlyWhite,
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: FitnessAppTheme.nearlyBlack.withOpacity(0.4),
                                    offset: Offset(8.0, 8.0),
                                    blurRadius: 8.0),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.add,
                                color: HexColor(mealsListData!.endColor),
                                size: 24,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: CircleAvatar(
              radius: 42,
              backgroundColor: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(mealsListData!.imagePath),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',

    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;

  int kacl;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: '../../../assets/images/s1.jpg',
      titleTxt: 'Breakfast',
      kacl: 525,
   
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MealsListData(
      imagePath: '../../../assets/images/s2.jpg',
      titleTxt: 'Lunch',
      kacl: 602,
    
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MealsListData(
      imagePath: '../../../assets/images/s3.jpg',
      titleTxt: 'Snack',
      kacl: 0,
   
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    MealsListData(
      imagePath: '../../../assets/images/s4.jpg',
      titleTxt: 'Dinner',
      kacl: 0,
   
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
