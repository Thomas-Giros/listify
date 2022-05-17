

class ListData {
  final int id;
  final String listName;
  final String description;
  final String username;
  final int parentID;
  final bool hasChildren;

  const ListData({
    required this.id,
    required this.listName,
    required this.description,
    required this.username,
    required this.parentID,
    required this.hasChildren,
  });

  ListData.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        listName = res["listName"],
        description = res["description"],
        username = res["username"],
        parentID = res["parentID"],
        hasChildren = res["hasChildren"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'listName': listName,
      'description': description,
      'username': username,
      'parentID': parentID,
      'hasChildren': hasChildren
    };
  }
}