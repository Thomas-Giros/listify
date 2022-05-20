import 'package:flutter/material.dart';
import 'package:listify/pages/NewListPage.dart';
import 'package:listify/pages/components/SearchBar.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/ViewListItem.dart';
import 'package:listify/pages/components/ActionButtons.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(goToHomePage: () {},buttonFunction: goToNewListPage, title: "My Lists",),
          SearchBar(),
          Expanded(child: ListView(children: [ViewListItem(parentID: -1,)])),
        ],
      ),
      floatingActionButton: ActionButtons(radius: 30 ,goToNewListPage: goToNewListPage,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  goToNewListPage(){
    Navigator.push(
      context,
      CustomPageRoute(
        child:  NewListPage(),
      ),
    );
  }
}