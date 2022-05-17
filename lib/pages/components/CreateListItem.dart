import 'package:flutter/material.dart';


class CreateListItem extends StatefulWidget {
  CreateListItem({
    Key? key,
    required this.parentID,
    this.parent
  }) : super(key: key);

  late int id = 0;
  late String title;
  late String username = "me";
  late String description;
  late int numberOfChildren;
  late int parentID;
  late _CreateListItemState? parent;
  late _CreateListItemState? current;


  @override
  State<CreateListItem> createState() => _CreateListItemState();
}

class _CreateListItemState extends State<CreateListItem> {
  late double _height = 0;
  List<CreateListItem> childrenList = [];
  final globalHeight = 180;
  // totalChildren is including itself as children of parent widget for height calculation
  int totalChildren = 1;

  bool open = false;

  @override
  Widget build(BuildContext context) {
    widget.current = this;
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
              children: buildList(context),
            ),
            Container(
              height: _height,
              child: Column(
                children: [Expanded(child: ListView(children: childrenList))],
              ),
            )

          ],
        ),
      ),
    );
  }


  List<Widget> buildList(BuildContext context) {
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
          widget.username.toUpperCase(),
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
    GlobalKey newkey = GlobalKey();
    CreateListItem child = CreateListItem(parentID: -1, parent: this,key: newkey,);
    setState(() {
      childrenList.add(child);
    });
    updateHeightOnCreate();
  }


  updateHeightOnDelete(int numberOfChildren){

    if (widget.parentID != 0){
      widget.parent!.setState(() {
        widget.parent?.totalChildren -= numberOfChildren ;
        widget.parent!._height -= globalHeight * (numberOfChildren);
        widget.parent?.updateHeightOnDelete(numberOfChildren);
      });
    }
  }

  updateHeightOnCreate(){
    setState(() {
      _height += globalHeight;
      totalChildren +=1;
    });
    if (widget.parentID != 0){
      widget.parent?.updateHeightOnCreate();
    }
  }

  void deleteElement() {
    if (widget.parentID != 0){
      widget.parent!.setState(() {
        List<CreateListItem> newchildrenList = [];

        for (var element in widget.parent!.childrenList) {
          if (element != widget){
            newchildrenList.add(element);
          }
        }
        widget.parent!.childrenList = newchildrenList;
        childrenList.clear();
      });
      updateHeightOnDelete(totalChildren);
    }
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({
    Key? key,
    required this.widget,
    required this.parentState,
  }) : super(key: key);

  final CreateListItem widget;
  final _CreateListItemState parentState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'List Title',
            ),
            style: Theme.of(context).textTheme.headline5,
            onSaved: (String? value) {
              print("wtv");
              if (value != null && value.isNotEmpty)
                parentState.setState(() {
                  widget.title = value;
                  print("$value");
                });
            },
          ),
        ),
        Spacer(),
        Text(
          widget.username.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}