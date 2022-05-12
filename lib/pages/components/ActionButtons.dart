import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
    required this.radius,
    required this.goToNewListPage,
  }) : super(key: key);

  final double radius;
  final Function() goToNewListPage;



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
            onPressed: goToNewListPage,
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


