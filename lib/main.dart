import 'package:flutter/material.dart';
import 'package:listify/data/services/DataBaseHandler.dart';
import 'package:listify/pages/HomePage.dart';
import 'package:listify/pages/SplashPage.dart';
import 'package:listify/pages/LoginPage.dart';
import 'package:listify/pages/AccountPage.dart';



typedef IntVoidFunc = void Function(int);

void main() {
  DatabaseHandler.initializeDB().then((value) {
    runApp(const MyApp());
  });

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
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/home': (_) => const HomePage(),

      },
    );
  }
}

