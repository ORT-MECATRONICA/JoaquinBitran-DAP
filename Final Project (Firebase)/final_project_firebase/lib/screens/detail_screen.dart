// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_firebase/domain/games.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatelessWidget {
  static const String name = 'detail_screen';

  const DetailScreen({
    super.key,
    required this.gameDetail,
    required this.onDelete,
    required this.onUpdate,
  });

  // Define functions
  final Games gameDetail;
  final Function(Games) onDelete;
  final Function(Games) onUpdate;

  // Edit game Function
  Future<void> _editGame(BuildContext context) async {
    final TextEditingController titleController =
        TextEditingController(text: gameDetail.title);
    final TextEditingController developerController =
        TextEditingController(text: gameDetail.developer);
    final TextEditingController descriptionController =
        TextEditingController(text: gameDetail.description);
    final TextEditingController imageUrlController =
        TextEditingController(text: gameDetail.urlimage);
    final TextEditingController yearController =
        TextEditingController(text: gameDetail.year.toString());

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Game'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Game Title'),
              ),
              TextField(
                controller: developerController,
                decoration: const InputDecoration(labelText: 'Developer'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(
                    labelText: 'Year (Will default to 0 if not an integer)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Check if the document exists
                  DocumentSnapshot docSnapshot = await FirebaseFirestore
                      .instance
                      .collection('games')
                      .doc(gameDetail.id)
                      .get();

                  if (!docSnapshot.exists) {
                    // If the document doesn't exist, show a message
                    const errorSnackBar = SnackBar(
                      content: Text('Game document not found.'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                    return;
                  }

                  // Update Firestore
                  await FirebaseFirestore.instance
                      .collection('games')
                      .doc(gameDetail.id)
                      .update({
                    'title': titleController.text,
                    'developer': developerController.text,
                    'description': descriptionController.text,
                    'urlimage': imageUrlController.text,
                    'year': int.tryParse(yearController.text) ?? 0,
                  });

                  // Create an updated Games object
                  Games updatedGame = Games(
                    id: gameDetail.id,
                    title: titleController.text,
                    developer: developerController.text,
                    description: descriptionController.text,
                    urlimage: imageUrlController.text,
                    year: int.tryParse(yearController.text) ?? 0,
                  );

                  // Call the onUpdate callback with the updated game data
                  onUpdate(updatedGame);

                  // Show confirmation snack bar
                  const gameEdited = SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Element changed'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(gameEdited);
                } catch (e) {
                  // Handle any errors
                  const errorSnackBar = SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Failed to update game. Please try again.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                }

                // Go back to Home Screen (Pops once to Detail Screen, and then to Home Screen)
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog without saving
              child: const Text('Cancel'),
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
        title: const Text('Game Details'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(50, 40, 50, 0.5),
              Color.fromRGBO(100, 90, 100, 0.5),
              Color.fromRGBO(150, 140, 150, 0.5),
              Color.fromRGBO(200, 190, 200, 0.5),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: ListView(
              children: [
                FittedBox(child: Image.network(gameDetail.urlimage)),
                const SizedBox(height: 16),
                Text(gameDetail.title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Developer: ${gameDetail.developer}',
                    style: const TextStyle(fontSize: 20)),
                Text('Year of release: ${gameDetail.year}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                Text(gameDetail.description,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _editGame(context);
                      },
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onDelete(gameDetail);
                        const gameErased = SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Element erased'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(gameErased);
                        context.pop(); // Return to the Home Screen
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
