import 'package:flutter/material.dart';
import 'package:listify/data/model/ListData.dart';
import 'package:listify/data/services/DataBaseHandler.dart';
import 'package:listify/pages/ModifyListPage.dart';
import 'package:listify/pages/components/ModifyListItem.dart';

import 'package:listify/pages/components/CustomPageRoute.dart';


class ViewListItem extends StatefulWidget {
  ViewListItem(
      {Key? key,
      this.id,
      this.title,
      this.username,
      this.description,
      this.hasChildren,
      required this.parentID,
      this.parentState})
      : super(key: key);

  final int? id;
  final String? title;
  final String? username;
  final String? description;
  final bool? hasChildren;
  final int parentID;
  late _ViewListItemState? parentState;

  @override
  State<ViewListItem> createState() => _ViewListItemState();
}

class _ViewListItemState extends State<ViewListItem> {
  List<ViewListItem> childrenList = [];
  final globalHeight = 180;
  // here totalChildren is not including itself as children of parent widget for height calculation
  double totalChildrenHeight = 0;

  bool open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: expand,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.black26, width: 1),
        ),
        color: Colors.white.withOpacity(0.7),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Column(
                children: buildElement(context),
              ),
              Container(
                height: totalChildrenHeight,
                child: Column(
                  children: [Expanded(child: ListView(children: childrenList))],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildListView(List<ListData> snapshot) {
    setState(() {
      snapshot.forEach((oneList) {
        GlobalKey newkey = GlobalKey();
        ViewListItem child = ViewListItem(
          id: oneList.id,
          title: oneList.listName,
          username: oneList.username,
          description: oneList.description,
          hasChildren: oneList.hasChildren,
          parentID: oneList.parentID,
          parentState: this,
          key: newkey,
        );

        childrenList.add(child);
        double childHeight = _textSize(
                child.description!, Theme.of(context).textTheme.titleMedium!)
            .height;
        childHeight += 80;

        updateHeightOnCreate(childHeight);
      });
    });
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width);
    return textPainter.size;
  }


  List<Widget> buildElement(BuildContext context) {
    if (widget.parentID == -1 && childrenList.isEmpty) {
      DatabaseHandler.getLists(0).then((snapshot) => buildListView(snapshot));
      return [];
    } else {
      if (widget.title != null) {
        return [
          Row(
            children: [
              Text(
                widget.title!.toUpperCase(),
                style: Theme.of(context).textTheme.headline5,
              ),
              Spacer(),
              Text(
                widget.username!.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    Navigator.push(
                      context,
                      CustomPageRoute(
                        child:  ModifyListPage(
                          modifyListItem: ModifyListItem(
                            parentID: -1,
                            id: widget.id,
                            title: widget.title,
                            username: widget.username,
                            description: widget.description,
                            hasChildren: widget.hasChildren,

                          ),
                        ),
                      ),
                    );
                  });
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Modify"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Copy"),
                    value: 2,
                  )
                ],
                icon: Icon(Icons.more_vert),
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
                  widget.description!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ];
      } else
        return [];
    }
  }

  updateHeightOnDelete(double childrenHeight) {
    setState(() {
      totalChildrenHeight -= childrenHeight;
      if (widget.parentID != -1) {
        widget.parentState?.updateHeightOnDelete(childrenHeight);
      }
    });
  }

  updateHeightOnCreate(double childHeight) {
    setState(() {
      totalChildrenHeight += childHeight;
    });

    if (widget.parentID != -1) {
      widget.parentState?.updateHeightOnCreate(childHeight);
    }
  }

  void deleteElement() {
    childrenList = [];
    updateHeightOnDelete(totalChildrenHeight);
  }

  expand() {
    if (widget.hasChildren != null && widget.hasChildren == true) {
      setState(() {
        if (!open) {
          DatabaseHandler.getLists(widget.id!)
              .then((snapshot) => buildListView(snapshot));
        } else {
          deleteElement();
        }
        open = !open;
      });
    }
  }
}
