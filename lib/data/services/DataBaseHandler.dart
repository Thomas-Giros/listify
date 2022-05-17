import 'package:supabase/supabase.dart';
import '../model/ListData.dart';

class DatabaseHandler {


  static late SupabaseClient supaBaseclient;

  static initializeDB() {
    const supabaseUrl = 'https://oyrsacdqbvhsiofaysuw.supabase.co';
    const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95cnNhY2RxYnZoc2lvZmF5c3V3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTE2NzUzMTEsImV4cCI6MTk2NzI1MTMxMX0.A4QAYqMGLiWfkFEeyFk6yk0lQt1eOZpJPaadF0hcqM0';
    supaBaseclient = SupabaseClient(supabaseUrl, supabaseKey);
  }

  static Future<List<ListData>> getLists(int parentID) async {
    // query data
    // parent ID with value 0 are considered to be main lists
    final selectResponse = await supaBaseclient
        .from('lists')
        .select()
        .eq('parentID', parentID)
        .order('id', ascending: true)
        .execute(count: CountOption.exact);
    if (selectResponse.error == null) {
      //print('response.data: ${selectResponse.data}');
    }
    print("db");
    final datalist = selectResponse.data as List;
    return datalist.map((e) => ListData.fromMap(e)).toList();
  }

   createList(String listName, String description, String username,int parentID, bool hasChildren) async {
    // query data
    // insert data
    final insertResponse = await supaBaseclient.from('lists').insert([
      {
        //'id': id,
        'listName': listName,
        'description': description,
        'username': username,
        'parentID': parentID,
        'hasChildren': hasChildren
      },
    ]).execute();

    if (insertResponse.error == null) {
      //print('insertResponse.data: ${insertResponse.data}');
    }
  }

  updateList(int id, String listName, String description, String username, int parentID, bool hasChildren) async {
    // update data
    final updateResponse = await supaBaseclient.from('lists').update(
        {
          'listName': listName,
          'description': description,
          'username': username,
          'parentID': parentID,
          'hasChildren': hasChildren
        })
        .eq('id', id)
        .execute();

    if (updateResponse.error == null) {
      //print('insertResponse.data: ${insertResponse.data}');
    }
  }

  deleteList(int id) async {
    // delete data
    final updateResponse = await supaBaseclient
        .from('lists')
        .delete()
        .eq('id', id)
        .execute();

    if (updateResponse.error == null) {
      //print('insertResponse.data: ${insertResponse.data}');
    }
  }

}
// tBEus2G2qp3Hxe4