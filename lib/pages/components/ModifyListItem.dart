import 'package:flutter/material.dart';
import 'package:listify/data/model/ListData.dart';
import 'package:listify/data/services/DataBaseHandler.dart';

class ModifyListItem extends StatefulWidget {
  ModifyListItem(
      {Key? key,
        this.id,
        this.title,
        this.username,
        this.description,
        this.hasChildren,
        required this.parentID,
        this.parentState})
      : super(key: key);

  late int? id;
  late String? title = "";
  late String? username;
  late String? description = "";
  late bool? hasChildren;
  late int parentID;
  late _ModifyListItemState? parentState;
  late _ModifyListItemState? current;

  @override
  State<ModifyListItem> createState() => _ModifyListItemState();
}

class _ModifyListItemState extends State<ModifyListItem> {
  List<ModifyListItem> childrenList = [];
  // here totalChildren is not including itself as children of parent widget for height calculation
  double totalChildrenHeight = 0;
  double itemHeight = 0;
  final double baseHeight = 180;

  late bool isExpanded = widget.parentID == -1;

  @override
  Widget build(BuildContext context) {
    widget.current = this;
    return GestureDetector(
      onTap: expand,
      child: buildCard(context),
    );
  }

  Card buildCard(BuildContext context) {
    return Card(
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
              height: itemHeight,
              child: Column(
                children: [Expanded(child: ListView(children: childrenList))],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildListView(List<ListData> snapshot) {
    setState(() {
      snapshot.forEach((oneList) {
        GlobalKey newkey = GlobalKey();
        ModifyListItem child = ModifyListItem(
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
        double childHeight = baseHeight;

        updateHeightOnCreate(childHeight);
      });
    });
  }

  List<Widget> buildElement(BuildContext context) {
    if (widget.parentID == -1 && childrenList.isEmpty) {
      if (widget.hasChildren!){
        DatabaseHandler.getLists(widget.id!).then((snapshot) => buildListView(snapshot));
        return [];
      } else {
        return  buildListElements(context);
      }
    } else {
      return buildListElements(context);
    }
  }

  List<Widget> buildListElements(BuildContext context) {
    return [
      Row(
        children: [
          buildTextFormField(context, true),
          Spacer(),
          Text(
            widget.username!.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      Row(
        children: [
          buildTextFormField(context, false),
        ],
      ),
      Container(
        margin: EdgeInsets.all(10.0),
        height: 25,
        child: buildListActionsRow(),
      ),
    ];
  }

  Row buildListActionsRow() {
    return Row(
      children: [
        Spacer(),
        RawMaterialButton(
          onPressed: deleteElement,
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.clear,
            size: 15,
          ),
          padding: EdgeInsets.all(2.0),
          shape: CircleBorder(),
        ),
        RawMaterialButton(
          onPressed: createElement,
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 15,
          ),
          padding: EdgeInsets.all(2.0),
          shape: CircleBorder(),
        ),
        Spacer(),
      ],
    );
  }

  Flexible buildTextFormField(BuildContext context, bool title) {
    TextFormField textFormField;
    if (title)
    {
      textFormField = TextFormField(
        initialValue: widget.title,
        onChanged: (value) {widget.title = value;},
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'List Title',
        ),
        style: Theme.of(context).textTheme.headline5,
      );
    } else
    {
      textFormField = TextFormField(
        initialValue: widget.description,
        onChanged: (value) {widget.description = value;},
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Description',
        ),
        style: Theme.of(context).textTheme.titleMedium,
      );
    }
    return Flexible(child: textFormField);
  }

  void createElement() {
    GlobalKey newkey = GlobalKey();
    // we use a value of -2 for new children items, so that they don't match existing id's
    ModifyListItem child = ModifyListItem(parentID: widget.id!, id : -2,parentState: this,key: newkey, username: "me",);
    setState(() {
      widget.hasChildren = true;
      childrenList.add(child);
    });

    double childHeight = baseHeight;
    if (!isExpanded) {expand();}
    updateHeightOnCreate(childHeight);
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

  void deleteElement() {
    if (widget.parentID != -1){
      if (childrenList.isNotEmpty){
        setState(() {
          childrenList.clear();
        });
      }
      widget.parentState!.setState(() {
        List<ModifyListItem> newChildrenList = [];

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
  }

  expand() {
    if (widget.hasChildren != null && widget.hasChildren == true) {
      setState(() {
        if (!isExpanded) {
          if (childrenList.isEmpty)
            {DatabaseHandler.getLists(widget.id!).then((snapshot) => buildListView(snapshot));}
          else
          {updateHeightOnExpand(totalChildrenHeight);}
        } else
        {updateHeightOnHide(totalChildrenHeight);}
        isExpanded = !isExpanded;
      });
    }
  }
}
