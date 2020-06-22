import 'package:flutter/material.dart';

import 'inshortCloner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Inshots Clone',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double screenHeight;
  List cardData = [
    {'photo': 'Photo 1', 'body': 'BodyData 1'},
    {'photo': 'Photo 2', 'body': 'BodyData 2'},
    {'photo': 'Photo 3', 'body': 'BodyData 3'},
    {'photo': 'Photo 4', 'body': 'BodyData 4'},
    {'photo': 'Photo 5', 'body': 'BodyData 5'},
    {'photo': 'Photo 6', 'body': 'BodyData 6'},
    {'photo': 'Photo 7', 'body': 'BodyData 7'},
    {'photo': 'Photo 8', 'body': 'BodyData 8'},
  ];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
            child:
                InshortUIPage(screenHeight: screenHeight, cardData: cardData)));
  }
}
