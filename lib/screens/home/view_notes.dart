import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedemo/main.dart';
import 'package:supabasedemo/screens/home/edit_note.dart';
import 'package:supabasedemo/services/supabase_service.dart';

import '../../model/note_model.dart';

final supaBaseClient = SupabaseClient(databaseUrl, databaseAnonKey);

class ViewNotesPage extends StatefulWidget {
  const ViewNotesPage({super.key});
  @override
  State<ViewNotesPage> createState() => _ViewNotesPageState();
}

class _ViewNotesPageState extends State<ViewNotesPage> {
  final _supaBaseClient = SupaBaseManager();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            addOrEdit(null);
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home Page"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Logout',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: read(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            debugPrint(snapshot.data.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
            if (snapshot.data != null) {
              List value = snapshot.data;
              if (value.isNotEmpty) {
                return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = NotesModel.fromJson(snapshot.data[index]);
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              data.title,
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              data.description,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    addOrEdit(data);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    delete(data);
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                return const Center(
                  child: Text(
                    'No data',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _supaBaseClient.logout(context);
        break;
    }
  }

  addOrEdit(data) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(notesModel: data),
      ),
    );

    if (result != null) {
      setState(() {});
    }
  }

  Future read() async {
    final userData = await supaBaseClient.from('todo').select();
    return userData;
  }

  void delete(NotesModel data) async {
    await supaBaseClient.from('todo').delete().eq('id', data.id);

    setState(() {});
  }
}
