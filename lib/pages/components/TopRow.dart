import 'package:flutter/material.dart';

class TopRow extends StatelessWidget {
  const TopRow({
    required this.goToHomePage,
    Key? key,
  }) : super(key: key);

  final double radius = 30;
  final Function() goToHomePage;

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
            "My lists".toUpperCase(),
            style: Theme.of(context).textTheme.headline2,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
