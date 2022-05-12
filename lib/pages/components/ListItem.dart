import 'package:flutter/material.dart';
import 'package:listify/pages/components/MyLists.dart';

class ListItem extends StatefulWidget {
  ListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.username,
    required this.description,
    required this.numberOfChildren,
    required this.parentID,
  }) : super(key: key);

  final int id;
  final String title;
  final String username;
  final String description;
  final int numberOfChildren;
  final int parentID;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  List<Widget> childrenList = [];
  double _height = 0;
  bool open = false;

  void expandList() {
    int i = widget.numberOfChildren;


    print("$i \n");
    setState(() {
      if (!open){
        childrenList.add(Expanded(child: MyLists(root: widget.id)));
        if(widget.parentID == 0  && widget.numberOfChildren != 0)
          _height = 600;
        else
          _height = 100.0 * i;
      } else {
        childrenList.clear();
        _height = 0.0;
      }
      open = !open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: expandList,
      child: Card(
        color: Colors.white.withOpacity(0.7),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Column(
                children: buildList(context),
              ),
              Container(
                height: _height,
                child: Column(
                  children: childrenList,
                ),
              )

            ],
          ),
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