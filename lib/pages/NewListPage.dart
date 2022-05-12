import 'package:flutter/material.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/ActionButtons.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';
import 'package:listify/pages/HomePage.dart';

class NewListPage extends StatefulWidget {
  const NewListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(goToHomePage: goToHomePage,),
          Text("data"),
        ],
      ),
      floatingActionButton: ActionButtons(radius: 30, goToNewListPage: goToNewListPage,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  goToHomePage(){
    Navigator.push(
      context,
      CustomPageRoute(
        child:  HomePage(title: "My Lists",),
      ),
    );
  }

  goToNewListPage(){
    Navigator.push(
      context,
      CustomPageRoute(
        child:  NewListPage(title: "New List",),
      ),
    );
  }
}