import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_taking_app/enterpin.dart';

class Createpin extends StatefulWidget {
  const Createpin({super.key});

  @override
  State<Createpin> createState() => _CreatepinState();
}

class _CreatepinState extends State<Createpin> {
  late Box pin;
  String? savedPin;
  String inputPin = '';

  @override
  void initState() {
    super.initState();
    pin = Hive.box('pin');
    savedPin = pin.get('pin');
  }

  void _showPinLengthAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PIN Length Error'),
          content: const Text('PIN must be at least 4 digits.'),
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

  void _showConfirmationAlert(BuildContext context) {
    // Implement your confirmation dialog here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm PIN Usage'),
          content: const Text('Would you like to use this PIN?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                pin.put('pin', inputPin);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Enterpin(previousPage: 'Create'),
                  ),
                );
              },
              child: const Text('Use PIN'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (savedPin == null) {
      return Scaffold(
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
                        "Create PIN",
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
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
                                  inputPin = inputPin.substring(
                                      0, inputPin.length - 1);
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
                              if (inputPin.length < 4) {
                                _showPinLengthAlert(context);
                              } else {
                                _showConfirmationAlert(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(20),
                            ),
                            child: const Text('OK',
                                style: TextStyle(fontSize: 20)),
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
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Enterpin(
              previousPage: "Create",
            ),
          ),
        );
      });
      return Container();
    }
  }
}