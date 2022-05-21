import 'package:flutter/material.dart';
import 'package:listify/pages/components/ModifyListItem.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';
import 'package:listify/pages/HomePage.dart';


class NewListPage extends StatefulWidget {
  NewListPage({Key? key}) : super(key: key);

  final ModifyListItem createListItem = ModifyListItem(parentID: -1, id: -2, hasChildren: false, username: "me",);

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
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

  saveListButton(){
    saveList(widget.createListItem);
  }

  saveList(ModifyListItem createListItem){
    if (createListItem.current != null && createListItem.current!.childrenList != []){
      String? title = createListItem.current!.widget.title;
      if (title!.isNotEmpty)
        print(title);

      createListItem.current!.childrenList.forEach((element) {
        saveList(element);
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