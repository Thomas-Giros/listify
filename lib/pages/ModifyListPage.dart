import 'package:flutter/material.dart';
import 'package:listify/pages/NewListPage.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/ModifyListItem.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';
import 'package:listify/pages/HomePage.dart';

class ModifyListPage extends StatefulWidget {
  ModifyListPage({Key? key, required this.modifyListItem}) : super(key: key);

  late ModifyListItem modifyListItem;

  @override
  State<ModifyListPage> createState() => _ModifyListPageState();
}

class _ModifyListPageState extends State<ModifyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(goToHomePage: goToHomePage, buttonFunction: updateListButton, title: "Modify"),
          SizedBox(height: 25,),
          Expanded(child: ListView(children: [widget.modifyListItem])),
        ],
      ),
    );
  }

  updateListButton(){
    updateList(widget.modifyListItem);
  }

  updateList(ModifyListItem modifyListItem){


    if (modifyListItem.current != null && modifyListItem.current!.childrenList != []){
      String title = modifyListItem.current!.widget.title!;
      print(title);

      modifyListItem.current!.childrenList.forEach((element) {
        updateList(element);
      });
    }
  }

  Expanded buildList() {

    return Expanded(child: ListView(children: [widget.modifyListItem]));
  }


  goToHomePage(){
    Navigator.push(
      context,
      CustomPageRoute(
        child:  HomePage(),
      ),
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