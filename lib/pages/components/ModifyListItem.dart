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
  late String? title;
  late String? username;
  late String? description;
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
    print("----");
    widget.current = this;
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
        double childHeight = _textSize(
            child.description!, Theme.of(context).textTheme.titleMedium!)
            .height;
        childHeight += baseHeight;

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
    print("here");
    if (widget.parentID == -1 && childrenList.isEmpty) {
      if (widget.hasChildren!){
        DatabaseHandler.getLists(widget.id!).then((snapshot) => buildListView(snapshot));
        return [];
      } else {
        print("else");

        return  buildListElementFromExisting(context);
      }

    } else {
      print("now");
      if (widget.title != null) {
        return buildListElementFromExisting(context);
      } else{
        print("why");
        return buildListElementFromScratch(context);
      }
    }
  }

  List<Widget> buildListElementFromExisting(BuildContext context) {
    return [
      Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: widget.title,
              onChanged: (value) {widget.title = value;},
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Spacer(),
          Text(
            widget.username!.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: widget.description,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.titleMedium,
              onSaved: (String? value) {
                if (value != null && value.isNotEmpty)
                  widget.description = value;
              },
            ),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.all(10.0),
        height: 25,
        child: Row(
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
        ),
      ),
    ];
  }

  List<Widget> buildListElementFromScratch(BuildContext context) {
    return [
      Row(
        children: [
          Flexible(
            child: TextFormField(
              onChanged: (value) {widget.title = value;},
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'List Title',
              ),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Spacer(),
          Text(
            widget.username!.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Description',
              ),
              style: Theme.of(context).textTheme.titleMedium,
              onSaved: (String? value) {
                if (value != null && value.isNotEmpty)
                  widget.description = value;
              },
            ),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.all(10.0),
        height: 25,
        child: Row(
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
        ),
      ),
    ];
  }

  void createElement() {
    if (!isExpanded) {expand();}
    GlobalKey newkey = GlobalKey();
    // we use a value of -2 for new children items, so that they don't match existing id's
    ModifyListItem child = ModifyListItem(parentID: widget.id!, id : -2,parentState: this,key: newkey, username: "me",);
    setState(() {
      widget.hasChildren = true;
      childrenList.add(child);
      print(childrenList.toString());
    });

    double childHeight = baseHeight;
    updateHeightOnCreate(childHeight);
  }

  updateHeightOnCreate(double childHeight) {
    setState(() {
      totalChildrenHeight += childHeight;
      itemHeight = totalChildrenHeight;
      print(totalChildrenHeight.toString());
      print(itemHeight.toString());

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
      print(itemHeight.toString());

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
        List<ModifyListItem> newchildrenList = [];

        for (var element in widget.parentState!.childrenList) {
          if (element != widget){
            newchildrenList.add(element);
          }
        }
        widget.parentState!.childrenList = newchildrenList;

        if (newchildrenList.isEmpty){
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
            {
              DatabaseHandler.getLists(widget.id!)
                  .then((snapshot) => buildListView(snapshot));
            }
          else {
            print("expand");
            updateHeightOnExpand(totalChildrenHeight);
          }
        } else {
          print("hide");
          updateHeightOnHide(totalChildrenHeight);
        }
        isExpanded = !isExpanded;
      });
    }
  }
}
