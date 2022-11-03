import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_notepad/db/my_db.dart';
import 'model/note.dart';

class AddNote extends StatefulWidget {
  final Note? note;

  const AddNote({Key? key, this.note}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtContent = TextEditingController();
  String appbarTitle = "";
  DateTime now = DateTime.now();

  final Random rnd = Random();
  late Color selectedColor;
  late int selectedIntColor;

  var colors = [
    Colors.pinkAccent,
    Colors.deepPurpleAccent,
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.deepOrangeAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.lightBlueAccent,
    Colors.indigoAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.cyanAccent,
    Colors.limeAccent,
    Colors.tealAccent
  ];

  @override
  void initState() {
    selectedColor = widget.note != null ? Color(int.parse(widget.note!.color.toString())) : colors[rnd.nextInt(colors.length)];
    selectedIntColor = selectedColor.value;
    txtTitle.text = widget.note?.title ?? "";
    txtContent.text = widget.note?.content ?? "";
    appbarTitle = widget.note != null ? "Update" : "Add";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
          actions: [
        IconButton(onPressed: () {
          widget.note == null ?
          MyDB.instance.createNote(Note(title: txtTitle.text,content: txtContent.text,color: selectedIntColor.toString(),date: date.toString())) :
          MyDB.instance.updateNote(Note(id:widget.note?.id, title: txtTitle.text,content: txtContent.text,color: selectedIntColor.toString(),date: date.toString()))
          ;
          Navigator.pop(context);
          }, icon: const Icon(Icons.save_outlined))
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: txtTitle,
                style: const TextStyle(fontWeight: FontWeight.w900),
                decoration: inputDecoration("Title"),
              ),
              TextField(
                controller: txtContent,
                decoration: inputDecoration("Content"),
                minLines: 8,
                maxLines: 15,
              ),
              MaterialColorPicker(
                colors: colors,
                allowShades: false,
                selectedColor: selectedColor,
                onMainColorChange: (value) =>
                    setState(() {
                      selectedColor = value as Color;
                      selectedIntColor = value!.value;
                    }),
                onColorChange: (Color color) {
                  // Handle color changes
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String title) {
    return InputDecoration(
      filled: true,
      fillColor:
          title == "Title" ? selectedColor : selectedColor.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: title == "Title"
            ? const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )
            : const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
      ),
      hintText: title,
    );
  }
}
