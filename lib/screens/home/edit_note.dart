import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasedemo/main.dart';

import '../../model/note_model.dart';

class EditNotePage extends StatefulWidget {
  final NotesModel? notesModel;
  const EditNotePage({super.key, this.notesModel});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

final _titleController = TextEditingController();
final _descriptionController = TextEditingController();
final supaBaseClient = SupabaseClient(databaseUrl, databaseAnonKey);

class _EditNotePageState extends State<EditNotePage> {
  bool isEdit = false;
  @override
  void initState() {
    super.initState();

    if (widget.notesModel != null) {
      isEdit = true;
      _titleController.text = widget.notesModel!.title;
      _descriptionController.text = widget.notesModel!.description;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Note' : 'Add Note',
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, "updated"),
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            child: TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            child: TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CupertinoButton(
            onPressed: () {
              isEdit ? update(widget.notesModel!) : create(context);
            },
            color: Colors.blueAccent,
            pressedOpacity: 0.3,
            child: Text(
              isEdit ? 'Update' : 'Add',
            ),
          ),
        ],
      ),
    );
  }

  void create(BuildContext context) async {
    Map userData = {
      //'id': const Uuid().v1(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    };
    await supaBaseClient.from('todo').insert(userData);
    _descriptionController.clear();
    _titleController.clear();
    if (!mounted) return;
    Navigator.of(context).pop("updated");
    showToast("Saved successfully");
  }

  void update(NotesModel data) async {
    Map updateMap = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    };
    await supaBaseClient.from('todo').update(updateMap).eq('id', data.id);
    _titleController.clear();
    _descriptionController.clear();
    if (!mounted) return;
    Navigator.of(context).pop("updated");
    showToast("Updated successfully");
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
