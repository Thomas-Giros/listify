import 'package:flutter/material.dart';

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
