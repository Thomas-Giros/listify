import 'package:flutter/material.dart';
import 'package:listify/pages/NewListPage.dart';
import 'package:listify/pages/components/SearchBar.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/MyLists.dart';
import 'package:listify/pages/components/ActionButtons.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(goToHomePage: goToHomePage,),
          SearchBar(),
          Expanded(
            child: MyLists(
              root: 0,
            ),
          ),
        ],
      ),
      floatingActionButton: ActionButtons(radius: 30 ,goToNewListPage: goToNewListPage,),
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