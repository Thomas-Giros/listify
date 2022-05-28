import 'package:flutter/material.dart';
import 'package:listify/data/services/DataBaseHandler.dart';
import 'package:listify/pages/components/ModifyListItem.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';
import 'package:listify/pages/HomePage.dart';
import 'package:listify/pages/ModifyListPage.dart';


class NewListPage extends StatefulWidget {
  NewListPage({Key? key}) : super(key: key);

  final ModifyListItem createListItem = ModifyListItem(parentID: -1, id: -2, hasChildren: false, username: "me",);

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  int numberOfElements = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(goToHomePage: goToHomePage, buttonFunction: saveListButton, title: "New List"),
          SizedBox(height: 25,),
          buildList(),
        ],
      ),
    );
  }

  void onModify() {
    Navigator.push(
      context,
      CustomPageRoute(
        child:  ModifyListPage(
          modifyListItem: ModifyListItem(
            parentID: -1,
            id: widget.createListItem.id,
            title: widget.createListItem.title,
            username: widget.createListItem.username,
            description: widget.createListItem.description,
            hasChildren: widget.createListItem.hasChildren,
          ),
        ),
      ),
    );
  }

  saveListButton(){
    determineLastElement(widget.createListItem);
    saveList(widget.createListItem, -1);
  }

  determineLastElement(ModifyListItem createListItem){
    if (createListItem.current != null ){
      numberOfElements++;
      if (createListItem.current!.childrenList.isNotEmpty){
        createListItem.current!.childrenList.forEach((element) {
          determineLastElement(element);
        });
      }
    }
  }

  saveList(ModifyListItem createListItem, int parentID){
    if (createListItem.current != null ){

      // TODO verify titles and description before saving

        // if it is a new list item without parent--> id == -2 and parentID == -1
        // without parent
        int pid = 0;
        if (parentID != -1){
          pid = parentID;
        }

        DatabaseHandler.createList(
            createListItem.current!.widget.title,
            createListItem.current!.widget.description,
            createListItem.current!.widget.username,
            pid,
            createListItem.current!.widget.hasChildren)
            .then((snapshot)
        {
          // we use the state of the widget to go to modifyList after everything has been saved
          if (parentID == -1){
            createListItem.current!.widget.id = snapshot.id;
          }

          numberOfElements--;
          if (createListItem.current!.childrenList.isNotEmpty) {
            createListItem.current!.childrenList.forEach((element) {
              saveList(element, snapshot.id);
            });
          }
          if (numberOfElements == 0){
            onModify();
          }
        });

    }
  }

  Expanded buildList() {

    return Expanded(child: ListView(children: [widget.createListItem]));
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