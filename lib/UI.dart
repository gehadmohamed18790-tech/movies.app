import 'package:flutter/material.dart';
import 'package:flutter_application_4/add_note_screen.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> notes = [
    {'title': 'Note 1', 'content': 'Content 1', 'isFavorite': false},
    {'title': 'Note 2', 'content': 'Content 2', 'isFavorite': true},
    {'title': 'Note 3', 'content': 'Content 3', 'isFavorite': false},
  ];

  void toggleFavorite(int index) {
    setState(() {
      notes[index]['isFavorite'] = !notes[index]['isFavorite'];
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("My Notes"),
          backgroundColor: Colors.grey,
        ),

     
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            
            final newNote = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNoteScreen(),
              ),
            );

            // 
            if (newNote != null) {
              setState(() {
                notes.add(newNote); 
              });
            }
          },
        ),

        body: TabBarView(
          children: [
            notesListView(notes),
            notesListView(
              notes.where((note) => note['isFavorite']).toList(),
            ),
          ],
        ),

        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.list), text: "All"),
            Tab(icon: Icon(Icons.favorite), text: "Favorites"),
          ],
        ),
      ),
    );
  }

  Widget notesListView(List<Map<String, dynamic>> displayNotes) {
    if (displayNotes.isEmpty) {
      return const Center(
        child: Text(
          "No Notes",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: displayNotes.length,
      itemBuilder: (context, index) {
        final note = displayNotes[index];

        return Card(
          color: Colors.grey[850],
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(
              note['title'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              note['content'],
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deleteNote(notes.indexOf(note));
                  },
                ),
                IconButton(
                  icon: Icon(
                    note['isFavorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.pink,
                  ),
                  onPressed: () {
                    toggleFavorite(notes.indexOf(note));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
