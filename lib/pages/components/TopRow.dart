import 'package:flutter/material.dart';

class TopRow extends StatelessWidget {
  const TopRow({
    required this.goToHomePage,
    required this.buttonFunction,
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;
  final double radius = 30;
  final Function() goToHomePage;
  final Function() buttonFunction;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: goToHomePage,
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.blue.shade800,
              child: Text(
                "T".toUpperCase(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Spacer(),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
          ),
          Spacer(),
          buildRawMaterialButton(),
        ],
      ),
    );
  }

  Widget buildRawMaterialButton() {
    if (title == "New List" || title == "Modify")
      {
        return RawMaterialButton(
          onPressed: buttonFunction,
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.save,
            size: radius,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        );
      }
    else {
      return RawMaterialButton(
        onPressed: buttonFunction,
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.add,
          size: radius,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      );
    }

  }
}
