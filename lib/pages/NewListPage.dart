import 'package:flutter/material.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/CreateListItem.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';
import 'package:listify/pages/HomePage.dart';


class NewListPage extends StatefulWidget {
  NewListPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final CreateListItem createListItem = CreateListItem(parentID: 0,);

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

  saveList(CreateListItem createListItem){


    if (createListItem.current != null && createListItem.current!.childrenList != []){
        String title = createListItem.current!.widget.title;
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
        child:  NewListPage(title: "New List",),
      ),
    );
  }
}