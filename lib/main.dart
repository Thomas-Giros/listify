import 'dart:math';

import 'package:flutter/material.dart';
import 'package:listify/data/model/ListData.dart';
import 'package:listify/data/services/DataBaseHandler.dart';

typedef IntVoidFunc = void Function(int);

void main() {
  DatabaseHandler.initializeDB();
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(),
          SearchBar(),
          Expanded(
            child: MyLists(
              root: 0,
            ),
          ),
        ],
      ),
      floatingActionButton: ActionButtons(radius: 30),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

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



  int _selectedIndex = 0;
  late List<ListTile> _elements;
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder(widget.root);
  }

  FutureBuilder<List<ListData>> buildFutureBuilder(int root) {
    return FutureBuilder(
        future: DatabaseHandler.getLists(root),
        builder: (context, AsyncSnapshot<List<ListData>> snapshot) {
          if (snapshot.hasData) {
            buildListView(snapshot);
            return ListView(
                children: _elements,
            );
          } else {
            return SizedBox();
          }
        });
  }

   buildListView(AsyncSnapshot<List<ListData>> snapshot) {
    int index = -1;
    _elements = snapshot.data!.map((oneList) {
      index ++;
      return ListTile(
        title: Column(
          children: [
            ListItem(
                id: oneList.id,
                title: oneList.listName,
                username: oneList.username,
                description: oneList.description,
                numberOfChildren: oneList.numberOfChildren),
            Container(height: _height,)
          ],
        ),
        selectedTileColor: Colors.lightGreen.withOpacity(0.5),
        selected: oneList.id == _selectedIndex,
        onTap: () {
          setState(() {
            _height = 100;
            _selectedIndex = oneList.id;
          });
        },
      );
    }).toList();

  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
      child: Card(
        color: Colors.grey[350],
        shape: StadiumBorder(),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          height: 35,
          child: Row(
            children: [
              const Icon(
                Icons.search,
                size: 25.0,
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                child: Text(
                  "Search".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({
    Key? key,
  }) : super(key: key);

  final double radius = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.blue.shade800,
            child: Text(
              "T".toUpperCase(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Spacer(),
          Text(
            "My lists".toUpperCase(),
            style: Theme.of(context).textTheme.headline2,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.search,
              size: radius,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.add,
              size: radius,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.username,
    required this.description,
    required this.numberOfChildren,
  }) : super(key: key);

  final int id;
  final String title;
  final String username;
  final String description;
  final int numberOfChildren;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  List<Widget> childrenList = [];

  void expandList() {
    int i = widget.numberOfChildren;
    print("$i \n");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white.withOpacity(0.7),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: buildList(context),
          ),
        ),
    );
  }

  List<Widget> buildList(BuildContext context) {
    return [
        Row(
          children: [
            Text(
              widget.title.toUpperCase(),
              style: Theme.of(context).textTheme.headline5,
            ),
            Spacer(),
            Text(
              widget.username.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                widget.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ];
  }

  @override
  void initState() {
    super.initState();
  }
}

/*
Container(
child: FutureBuilder(
future: DatabaseHandler.getLists(widget.id),
builder : (context, AsyncSnapshot<List<ListData>> snapshot) {
if (snapshot.data != null && snapshot.data!.isNotEmpty){
expand(snapshot.data!.length);
return Expanded(
child: ListView(
children: snapshot.data!.map(
(oneList) =>
ListItem(
id: oneList.id,
title: oneList.listName,
username: oneList.username,
description: oneList.description,
),
).toList()
),
);
} else {
return Text(
"fin",
style: Theme.of(context).textTheme.titleMedium,);
}
}
),
),*/
