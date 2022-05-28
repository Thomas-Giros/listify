import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listify/data/model/ListData.dart';
import 'package:listify/data/services/DataBaseHandler.dart';
import 'package:listify/pages/ModifyListPage.dart';
import 'package:listify/pages/components/ModifyListItem.dart';

import 'package:listify/pages/components/CustomPageRoute.dart';


class ViewListItem extends StatefulWidget {
  ViewListItem(
      {Key? key,
      this.id = -2,
      this.title = "",
      this.username = "",
      this.description = "",
      this.hasChildren = false,
      this.childrenListData = const [],
      required this.parentID,
      this.parentState})
      : super(key: key);

  final int id;
  final String title;
  final String username;
  final String description;
  late bool hasChildren;
  final List<ListData> childrenListData;
  final int parentID;
  late _ViewListItemState? parentState;

  @override
  State<ViewListItem> createState() => _ViewListItemState();
}

class _ViewListItemState extends State<ViewListItem> {
  List<ViewListItem> childrenList = [];
  final double baseHeight = 65;
  // here totalChildren is not including itself as children of parent widget for height calculation
  double totalChildrenHeight = 0;
  double itemHeight = 0;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: expand,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.black26, width: 1),
        ),
        color: Colors.white.withOpacity(0.7),
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 3),
                child: Column(
                  children: buildElement(context),
                ),
              ),
              Container(
                height: itemHeight,
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
      for (var oneList in snapshot) {
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
                child.description, Theme.of(context).textTheme.titleMedium!)
            .height;
        childHeight += baseHeight;

        updateHeightOnCreate(childHeight);
      }
    });
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width - 10);
    return textPainter.size;
  }


  List<Widget> buildElement(BuildContext context) {
    if (widget.parentID == -1 && widget.childrenListData.isEmpty && childrenList.isEmpty) {
      DatabaseHandler.getListsByParentID(0).then((snapshot) => buildListView(snapshot));
      return [];
    } else if (widget.parentID == -1 && childrenList.isEmpty && widget.childrenListData.isNotEmpty){
      buildListView(widget.childrenListData);
      print("fuck");
      return [];
    } else {
      if (widget.title.isNotEmpty) {
        return [
          Row(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              const Spacer(),
              Text(
                widget.username.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    if (value == 1){
                      onModify();
                    } else if (value == 2){
                      onCopy();
                    } else if (value == 3){
                      onDelete(widget.id,widget.hasChildren);
                      deleteElementUI();
                    }
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Modify"),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text("Copy"),
                    value: 2,
                  ),
                  const PopupMenuItem(
                    child: Text("Delete"),
                    value: 3,
                  )
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
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
          const SizedBox(
            height: 5,
          ),
        ];
      } else {
        return [];
      }
    }
  }

  updateHeightOnCreate(double childHeight) {
    setState(() {
      totalChildrenHeight += childHeight;
      itemHeight = totalChildrenHeight;
    });
    if (widget.parentID != -1) {
      widget.parentState?.updateHeightOnCreate(childHeight);
    }
  }

  updateHeightOnExpand(double childrenHeight) {
    setState(() {
      itemHeight += childrenHeight;
      if (widget.parentID != -1) {
        widget.parentState?.totalChildrenHeight += childrenHeight;
        widget.parentState?.updateHeightOnExpand(childrenHeight);
      }
    });
  }

  updateHeightOnDelete(double childrenHeight) {
    setState(() {
      totalChildrenHeight -= childrenHeight;
      itemHeight = totalChildrenHeight;
      if (widget.parentID != -1) {
        widget.parentState?.updateHeightOnDelete(childrenHeight);
      }
    });
  }

  updateHeightOnHide(double childrenHeight) {
    setState(() {
      itemHeight -= childrenHeight;
      if (widget.parentID != -1) {
        widget.parentState?.totalChildrenHeight -= childrenHeight;
        widget.parentState?.updateHeightOnHide(childrenHeight);
      }
    });
  }

  expand() {
    if (widget.hasChildren != null && widget.hasChildren == true) {
      setState(() {
        if (!isExpanded) {
          if (childrenList.isEmpty)
          {DatabaseHandler.getListsByParentID(widget.id).then((snapshot) => buildListView(snapshot));}
          else
          {updateHeightOnExpand(totalChildrenHeight);}
        } else
        {updateHeightOnHide(totalChildrenHeight);}
        isExpanded = !isExpanded;
      });
    }
  }

  void onModify() {
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
  }

  void onCopy() {
    Clipboard.setData(ClipboardData(text: "email")).then((_){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email address copied to clipboard")));
    });
  }

  void deleteElementUI() {
      if (childrenList.isNotEmpty){
        setState(() {
          childrenList.clear();
        });
      }
      widget.parentState!.setState(() {
        List<ViewListItem> newChildrenList = [];

        for (var element in widget.parentState!.childrenList) {
          if (element != widget){
            newChildrenList.add(element);
          }
        }
        widget.parentState!.childrenList = newChildrenList;

        if (newChildrenList.isEmpty){
          widget.parentState!.widget.hasChildren = false;
        }

      });
      if (isExpanded){
        updateHeightOnDelete(totalChildrenHeight + baseHeight);
      } else {
        updateHeightOnDelete(baseHeight);
      }
  }

  void onDelete(int id, bool hasChildren) {
    // TODO confirmation pop-up for deleting a list

    if (hasChildren == true) {
      print("$id");
        DatabaseHandler.getListsByParentID(id).then((snapshot) {
        for (var element in snapshot) {
          onDelete(element.id, element.hasChildren);
        }
        DatabaseHandler.deleteList(id);
      });

    } else {
      print("$id");
      DatabaseHandler.deleteList(id);
    }
  }
}
