import 'package:flutter/material.dart';
import 'package:flutter_notepad/add_note.dart';
import 'model/note.dart';
import 'db/my_db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note>? noteList;
  bool isList = true;

  @override
  void initState() {
    refreshList();
    super.initState();
  }

  @override
  void dispose() {
    MyDB.instance.close();
    super.dispose();
  }

  Future refreshList() async {
    setState(() {
      MyDB.instance.getNotes().then((value) => noteList = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note Application"),
        actions: [IconButton(onPressed: (){
          setState(() {
            isList = !isList;
          });
        }, icon: isList ? const Icon(Icons.view_list_rounded) : const Icon(Icons.grid_on))],
      ),
      body: FutureBuilder(
        future: MyDB.instance.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return noteList!.isEmpty
              ? const Center(
                  child: Text("Click ✚ to Create Note"),
                )
              // : generateListView();
              : isList ? generateListView() :generateGridView() ;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AddNote();
              },
            ),
          );
          refreshList();
        },
      ),
    );
  }

  Widget generateListView() {
    return ListView.builder(
      itemCount: noteList?.length,
      itemBuilder: (context, index) {
        return Card(
          color: Color(int.parse(noteList![index].color.toString())),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: ListTile(
                    title: Text(
                      noteList![index].title.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      softWrap: false,
                    ),
                    subtitle: Text(
                      noteList![index].content.toString(),
                      maxLines: 3,
                      softWrap: false,
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddNote(
                              note: noteList![index],
                            );
                          },
                        ),
                      );
                      refreshList();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      MyDB.instance.deleteNote(noteList![index].id ?? 0);
                      refreshList();
                    },
                    child: const Icon(Icons.delete_outline,
                        color: Colors.black54),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget generateGridView() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      semanticChildCount: 5,
      itemCount: noteList?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return AddNote(
                    note: noteList![index],
                  );
                },
              ),
            );
            refreshList();
          },
          child: Card(
            color: Color(int.parse(noteList![index].color.toString())),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  ListTile(
                    title: Text(
                      noteList![index].title.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      softWrap: false,
                    ),
                    subtitle: Text(
                      noteList![index].content.toString(),
                      maxLines: 8,
                      softWrap: false,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        MyDB.instance.deleteNote(noteList![index].id ?? 0);
                        refreshList();
                      },
                      child: const Icon(Icons.delete_outline,color: Colors.black54),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
