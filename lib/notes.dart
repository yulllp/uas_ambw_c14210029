import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes_taking_app/enterpin.dart';
import 'package:notes_taking_app/notedetail.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late Box notes;

  @override
  void initState() {
    super.initState();
    notes = Hive.box('notes');
  }

  @override
  Widget build(BuildContext context) {
    print(notes.values);
    if (notes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Notes',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Enterpin(
                      previousPage: "Edit",
                    ),
                  ),
                );
              },
              child: const Text(
                'Edit pin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'No notes available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notedetail()),
            ).then(
              (result) {
                if (result == true) {
                  setState(() {
                    notes = Hive.box('notes');
                  });
                }
              },
            );
          },
          backgroundColor: Colors.white10, // Set the background color to grey
          shape: const CircleBorder(), // Ensure the button is round
          child: const Icon(
            Icons.edit_document,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Notes',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Enterpin(
                      previousPage: "Edit",
                    ),
                  ),
                );
              },
              child: const Text(
                'Edit pin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 30.0,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            // final note = notes.getAt(index) as Map;
            final note = notes.getAt(notes.length - index - 1) as Map;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notedetail(noteKey: notes.length - index - 1), //notekey: index for sort based on updated
                  ),
                ).then(
                  (result) {
                    if (result == true) {
                      setState(() {
                        notes = Hive.box('notes');
                      });
                    }
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        note['content'] ?? 'No content',
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note['title'] ?? 'No Title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created ${DateFormat('dd/MM/yyyy, HH:mm').format(
                      DateTime.parse(
                        note['created'],
                      ),
                    )}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  Text(
                    'Updated ${DateFormat('dd/MM/yyyy, HH:mm').format(
                      DateTime.parse(
                        note['updated'],
                      ),
                    )}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notedetail()),
            ).then(
              (result) {
                if (result == true) {
                  setState(() {
                    notes = Hive.box('notes');
                  });
                }
              },
            );
          },
          backgroundColor: Colors.white10,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.edit_document,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
