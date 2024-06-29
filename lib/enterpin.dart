import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_taking_app/editpin.dart';
import 'package:notes_taking_app/notes.dart';

class Enterpin extends StatefulWidget {
  final String? previousPage;
  const Enterpin({super.key, this.previousPage});

  @override
  State<Enterpin> createState() => _EnterpinState();
}

class _EnterpinState extends State<Enterpin> {
  late Box pin;
  String? savedPin;
  String inputPin = '';

  @override
  void initState() {
    super.initState();
    pin = Hive.box('pin');
    savedPin = pin.get('pin');
  }

  void _showIncorrectAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inccorect'),
          content: const Text('Incorrect Pin'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Icon(
          Icons.lock,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: inputPin.isEmpty ? 1.0 : 0.0,
                child: const Column(
                  children: [
                    Text(
                      "Enter PIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Your PIN must be at least 4 digits",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // Adjust the multiplier as needed
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: inputPin.isNotEmpty
                          ? List.generate(
                              inputPin.length,
                              (index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    Icons.circle,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          : [
                              const SizedBox(height: 16)
                            ], // Maintain height when empty
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  for (var row in ['123', '456', '789'])
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.split('').map((number) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                inputPin += number;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(20),
                            ),
                            child: Text(number,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white)),
                          );
                        }).toList(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (inputPin.isNotEmpty) {
                              setState(() {
                                inputPin =
                                    inputPin.substring(0, inputPin.length - 1);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(Icons.backspace, size: 24),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              inputPin += '0';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child:
                              const Text('0', style: TextStyle(fontSize: 24)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (inputPin == savedPin) {
                              if (widget.previousPage == "Create") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Notes(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Editpin(),
                                  ),
                                );
                              }
                            } else {
                              _showIncorrectAlert(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                          ),
                          child:
                              const Text('OK', style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
