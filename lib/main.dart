import 'package:flutter/material.dart';
import 'package:listify/data/services/DataBaseHandler.dart';
import 'package:listify/pages/HomePage.dart';

typedef IntVoidFunc = void Function(int);

void main() {
  DatabaseHandler.initializeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

