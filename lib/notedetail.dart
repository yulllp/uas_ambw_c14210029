import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Notedetail extends StatefulWidget {
  final int? noteKey;
  const Notedetail({super.key, this.noteKey});

  @override
  State<Notedetail> createState() => _NotedetailState();
}

class _NotedetailState extends State<Notedetail> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final Box notesBox = Hive.box('notes');

  @override
  void initState() {
    super.initState();
    if (widget.noteKey != null) {
      final note = notesBox.getAt(widget.noteKey!) as Map;
      _titleController.text = note['title'] ?? 'No Title';
      _contentController.text = note['content'] ?? '';
    }
  }

  void _saveNote() {
    final title =
        _titleController.text.isEmpty ? 'No Title' : _titleController.text;
    final content = _contentController.text;
    final now = DateTime.now().toString();

    if (widget.noteKey == null) {
      notesBox.add(
          {'title': title, 'content': content, 'created': now, 'updated': now});
    } else {
      notesBox.putAt(widget.noteKey!, {
        'title': title,
        'content': content,
        'created': notesBox.getAt(widget.noteKey!)['created'],
        'updated': now
      });
    }
    // _sortNotesBox();
    Navigator.pop(context, true);
    print(notesBox.values);
  }

  // void _sortNotesBox() {
  //   List<Map<dynamic, dynamic>> sortedNotes =
  //       List<Map<dynamic, dynamic>>.from(notesBox.values);
  //   sortedNotes.sort((a, b) =>
  //       DateTime.parse(b['updated']).compareTo(DateTime.parse(a['updated'])));

  //   for (int i = 0; i < sortedNotes.length; i++) {
  //     notesBox.putAt(i, sortedNotes[i]);
  //   }
  // }

  void _deleteNote() {
    if (widget.noteKey != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Delete the note and close the dialog
                  notesBox.deleteAt(widget.noteKey!);
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pop(context, true); // Return true to indicate deletion
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noteKey == null ? 'New Note' : 'Edit Note',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          if (widget.noteKey != null)
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                _deleteNote();
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(
                    color: Colors.white10,
                    fontSize: 24), // Change hint text color
                border: InputBorder.none, // Remove border
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0), // Optional padding
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 18),
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  hintStyle: TextStyle(
                      color: Colors.white10,
                      fontSize: 18), // Change hint text color
                  border: InputBorder.none, // Remove border
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0), // Optional padding
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}