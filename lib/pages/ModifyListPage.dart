import 'package:flutter/material.dart';
import 'package:listify/pages/NewListPage.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/ModifyListItem.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';
import 'package:listify/pages/HomePage.dart';
import 'package:listify/data/services/DataBaseHandler.dart';

class ModifyListPage extends StatefulWidget {
  ModifyListPage({Key? key, required this.modifyListItem}) : super(key: key);

  late ModifyListItem modifyListItem;

  @override
  State<ModifyListPage> createState() => _ModifyListPageState();
}

class _ModifyListPageState extends State<ModifyListPage> {
  int numberOfElements = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(
              goToHomePage: goToHomePage,
              buttonFunction: updateListButton,
              title: "Modify"),
          const SizedBox(
            height: 25,
          ),
          Expanded(child: ListView(children: [widget.modifyListItem])),
        ],
      ),
    );
  }

  updateListButton() {
    updateList(widget.modifyListItem, widget.modifyListItem.parentID);
  }

  updateList(ModifyListItem modifyListItem, int parentID) {
    if (modifyListItem.current != null ) {


      // if the item already is in the database
      if (modifyListItem.id != -2){
        // if the ITem has been modified we update it, otherwise we just go to children
        if (modifyListItem.current!.widget.hasBeenModified){
          DatabaseHandler.updateList(
              modifyListItem.current!.widget.id,
              modifyListItem.current!.widget.title,
              modifyListItem.current!.widget.description,
              modifyListItem.current!.widget.username,
              modifyListItem.current!.widget.hasChildren)
              .then((snapshot) {

            afterUpdated(modifyListItem, modifyListItem.id);

          });
        } else {
          afterUpdated(modifyListItem, modifyListItem.id);
        }
      } else // if the element is new we must create one on the database
      {
        DatabaseHandler.createList(
            modifyListItem.current!.widget.title,
            modifyListItem.current!.widget.description,
            modifyListItem.current!.widget.username,
            parentID,
            modifyListItem.current!.widget.hasChildren)
            .then((snapshot) {
          afterUpdated(modifyListItem, snapshot.id);
        });
      }
    }
  }

  afterUpdated(ModifyListItem modifyListItem, int id){
    numberOfElements--;

    if (modifyListItem.current!.childrenList.isNotEmpty){
      for (var element in modifyListItem.current!.childrenList) {
        updateList(element, id);
      }
    }
    if (numberOfElements == 0){
      onModify();
    }
  }

  Expanded buildList() {
    return Expanded(child: ListView(children: [widget.modifyListItem]));
  }

  void onModify() {
    Navigator.push(
      context,
      CustomPageRoute(
        child:  ModifyListPage(
          modifyListItem: ModifyListItem(
            parentID: -1,
            id: widget.modifyListItem.id,
            title: widget.modifyListItem.title,
            username: widget.modifyListItem.username,
            description: widget.modifyListItem.description,
            hasChildren: widget.modifyListItem.hasChildren,
          ),
        ),
      ),
    );
  }

  goToHomePage() {
    Navigator.push(
      context,
      CustomPageRoute(
        child: HomePage(),
      ),
    );
  }

  goToNewListPage() {
    Navigator.push(
      context,
      CustomPageRoute(
        child: NewListPage(),
      ),
    );
  }
}
