import 'package:flutter/material.dart';

import 'package:pushnotificationexample/screens/home_sc.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter Chat',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,

      ),
      home: HomeScreen(),

    );
  }
}


