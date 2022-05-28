import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listify/data/services/DataBaseHandler.dart';
import 'package:listify/pages/NewListPage.dart';
import 'package:listify/pages/components/TopRow.dart';
import 'package:listify/pages/components/ViewListItem.dart';
import 'package:listify/pages/components/CustomPageRoute.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchValue = "";
  ViewListItem _viewListItem = ViewListItem(parentID: -1,key: GlobalKey(),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopRow(
            goToHomePage: () {},
            buttonFunction: goToNewListPage,
            title: "My Lists",
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 25.0,
                  color: Colors.black,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-45,
                    child: buildTextFormField(context)),
              ],
            ),
          ),
          Expanded(
              child: ListView(
                  children: [_viewListItem],
              ),
          ),
        ],
      ),
    );
  }

  TextFormField buildTextFormField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.go,
      onFieldSubmitted:(value) {
        search(value);
      },
          maxLength: 30,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onChanged: (value) {
            if (_searchValue != value) {
              _searchValue = value;
            }
          },
          decoration: const InputDecoration(
            counterText: "",
            isDense: true,
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            hintText: 'Search by title',
          ),
          style: Theme.of(context).textTheme.titleMedium,
        );
  }

  goToNewListPage() {
    Navigator.push(
      context,
      CustomPageRoute(
        child: NewListPage(),
      ),
    );
  }

  void search(String value) {
    DatabaseHandler.getListsByTitleSearch(value).then((snapshot) {
      setState(() {
        _viewListItem = ViewListItem(parentID: -1,childrenListData: snapshot,key: GlobalKey(),);
      });
    });

  }
}
