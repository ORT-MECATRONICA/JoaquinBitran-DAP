// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_firebase/domain/games.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class DetailScreenExtras {
  // Define my functions when passing to the detail screen
  final Games game;
  final Function(Games) onDelete;
  final Function(Games) onUpdate;

  DetailScreenExtras(this.game, this.onDelete, this.onUpdate);
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Games> newGamesList = [];

  @override
  void initState() {
    super.initState();
    getGames();
  }

  Future<void> getGames() async {
    try {
      // Retrieve all documents from the games
      final querySnapshot = await _firestore.collection('games').get();

      // Map each document to a Games instance using fromFirestore
      final games = querySnapshot.docs.map((doc) {
        // Use doc to access a specific document from a collection in Firestore
        return Games.fromFirestore(doc, null);
      }).toList();

      setState(() {
        newGamesList = games;
      });
    } catch (e) {
      print("Error fetching games: $e");
    }
  }

  // Add games Function
  Future<void> _addGame(String id, String title, String developer,
      String description, String imageUrl, String year) async {
    final newGameID = FirebaseFirestore.instance
        .collection('games')
        .doc(); // Create a new unique ID for the new game
    final newGame = Games(
      // Add a game with all the parameters previously defined
      id: newGameID.id,
      title: title,
      developer: developer,
      description: description,
      urlimage: imageUrl,
      year: int.tryParse(year) ?? 0,
    );

    try {
      // Wait for firestore and add a game
      await _firestore
          .collection('games')
          .doc(newGame.id)
          .set(newGame.toFirestore());
      setState(() {
        // Refreshes the UI
        newGamesList.add(newGame);
      });
    } catch (e) {
      // Error handling
      print("Error adding game: $e");
    }
  }

  // Update games Function
  Future<void> _updateGame(Games updatedGame) async {
    // Replaces old documents in the collection with new ones
    try {
      await _firestore
          .collection('games')
          .doc(updatedGame.id)
          .update(updatedGame.toFirestore()); // Uploads the game to Firestore
      setState(() {
        // Refreshes the UI
        int index = newGamesList.indexWhere((game) =>
            game.id ==
            updatedGame
                .id); // Searches for the list item whose id matches the one of the updated game
        if (index != -1) {
          // Makes sure a matching game is found, if not the index would return -1
          newGamesList[index] = updatedGame;
        }
      });
    } catch (e) {
      // Error handling
      print("Error updating game: $e");
    }
  }

  // Delete games Function
  Future<void> _deleteGame(Games game) async {
    try {
      await _firestore
          .collection('games')
          .doc(game.id)
          .delete(); // Function that deletes the item
      setState(() {
        // Refreshes the UI
        newGamesList.remove(game);
      });
    } catch (e) {
      // Error handling
      print("Error deleting game: $e");
    }
  }

  // Get URL for the images
  Widget _getPoster(String urlimage) {
    // Gets the URL and returns it as an image
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Image.network(urlimage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/add', extra: _addGame);
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: newGamesList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: newGamesList.length,
                itemBuilder: (context, index) {
                  Games gameElement = newGamesList[index];
                  return Card(
                    color: const Color.fromRGBO(240, 235, 240, 1),
                    child: ListTile(
                      leading: _getPoster(gameElement.urlimage),
                      title: Text(gameElement.title),
                      subtitle: Text('Developer: ${gameElement.developer}'),
                      trailing: const Icon(Icons.arrow_circle_right_sharp),
                      onTap: () => context.push(
                        '/detail',
                        extra: DetailScreenExtras(
                            gameElement, _deleteGame, _updateGame),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
