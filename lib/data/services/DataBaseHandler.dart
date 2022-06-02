import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/ListData.dart';

class DatabaseHandler {


  static late SupabaseClient supaBaseclient;

  static Future<void> initializeDB() async {
    const supabaseUrl = 'https://oyrsacdqbvhsiofaysuw.supabase.co';
    const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95cnNhY2RxYnZoc2lvZmF5c3V3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTE2NzUzMTEsImV4cCI6MTk2NzI1MTMxMX0.A4QAYqMGLiWfkFEeyFk6yk0lQt1eOZpJPaadF0hcqM0';
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    supaBaseclient = SupabaseClient(supabaseUrl, supabaseKey);
  }

  static Future<List<ListData>> getListsByParentID(int parentID) async {
    // query data
    // parent ID with value 0 are considered to be main lists
    final selectResponse = await supaBaseclient
        .from('lists')
        .select()
        .eq('parentID', parentID)
        .order('listName', ascending: true)
        .execute(count: CountOption.exact);
    if (selectResponse.error == null) {
      print("db getlist");
    }

    final datalist = selectResponse.data as List;
    return datalist.map((e) => ListData.fromMap(e)).toList();
  }

  static Future<List<ListData>> getListsByTitleSearch(String search) async {

    String searchString = search.trim().replaceAll("  ", " ");
    if (search.split(" ").length > 1){
      searchString = "'" + search.trim().replaceAll("  ", " ").replaceAll(" ", "' | '") + "'";
    }

    // query data
    // parent ID with value 0 are considered to be main lists
    final selectResponse = await supaBaseclient
        .from('lists')
        .select()
        .eq("parentID", 0)
        .textSearch('listName', searchString)
        .order('listName', ascending: true)
        .execute(count: CountOption.exact);
    if (selectResponse.error == null) {
      print("db getlist by title search");
    }

    final datalist = selectResponse.data as List;
    return datalist.map((e) => ListData.fromMap(e)).toList();
  }

  static Future<List<ListData>> getListsByUsernameSearch(String search) async {
    // query data
    // parent ID with value 0 are considered to be main lists
    final selectResponse = await supaBaseclient
        .from('lists')
        .select()
        .eq("parentID", 0)
        .textSearch('username', search)
        .order('username', ascending: true)
        .execute(count: CountOption.exact);
    if (selectResponse.error == null) {
      print("db getlist by username search");
    }

    final datalist = selectResponse.data as List;
    return datalist.map((e) => ListData.fromMap(e)).toList();
  }

   static Future<ListData> createList(String listName, String description, String username,int parentID, bool hasChildren) async {
    // query data
    // insert data
    final insertResponse = await supaBaseclient.from('lists').insert([
      {
        //'id': id,
        'listName': listName,
        'description': description,
        'username': username,
        'parentID': parentID,
        'hasChildren': hasChildren},
    ]).execute();
    if (insertResponse.error == null) {
      print("db createList");
    }
    final datalist = insertResponse.data as List;
    return datalist.map((e) => ListData.fromMap(e)).toList()[0];
  }

  static Future<ListData> updateList(int id, String listName, String description, String username, bool hasChildren) async {
    // update data
    final updateResponse = await supaBaseclient.from('lists').update(
        {
          'listName': listName,
          'description': description,
          'username': username,
          'hasChildren': hasChildren
        })
        .eq('id', id)
        .execute();
    if (updateResponse.error == null) {
      print("db updateList");
    }
    final datalist = updateResponse.data as List;
    return datalist.map((e) => ListData.fromMap(e)).toList()[0];
  }

  static Future<bool> deleteList(int id) async {
    // delete data
    final deleteResponse = await supaBaseclient
        .from('lists')
        .delete()
        .eq('id', id)
        .execute();
    if (deleteResponse.error == null) {
      print("db delete list");
      return true;
    } else{
      return false;
    }
  }

}
// mot de passe supabase tBEus2G2qp3Hxe4