import 'package:flutter/material.dart';
import 'package:listify/pages/components/ListItem.dart';
import 'package:listify/data/model/ListData.dart';
import 'package:listify/data/services/DataBaseHandler.dart';


class MyLists extends StatefulWidget {
  MyLists({
    Key? key,
    required this.root,
  }) : super(key: key);
  final int root;

  @override
  State<MyLists> createState() => _MyListsState();
}


class _MyListsState extends State<MyLists> {

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder(widget.root);
  }

  FutureBuilder<List<ListData>> buildFutureBuilder(int root) {
    return FutureBuilder(
        future: DatabaseHandler.getLists(root),
        builder: (context, AsyncSnapshot<List<ListData>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: buildListView(snapshot),
            );
          } else {
            return SizedBox();
          }
        });
  }

  List<ListItem> buildListView(AsyncSnapshot<List<ListData>> snapshot) {
    return snapshot.data!.map((oneList) {
      return
        ListItem(
          id: oneList.id,
          title: oneList.listName,
          username: oneList.username,
          description: oneList.description,
          numberOfChildren: oneList.numberOfChildren,
          parentID: oneList.parentID,);
    }).toList();
  }
}