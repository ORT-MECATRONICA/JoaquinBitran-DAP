import 'package:cloud_firestore/cloud_firestore.dart';

// Create Class
class Games {
  String id;
  String title;
  String developer;
  String description;
  String urlimage;
  int year;

  Games({
    required this.id,
    required this.title,
    required this.developer,
    required this.description,
    required this.urlimage,
    required this.year,
  });

  // Map data to send to Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'developer': developer,
      'description': description,
      'urlimage': urlimage,
      'year': year,
    };
  }

  // Fetch data as a map and convert it to a Games class
  factory Games.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data =
        snapshot.data(); // Retrieve the data from the snapshot as a Map
    return Games(
      // Convert it to a Games Map
      id: data?['id'] ?? '',
      title: data?['title'] ?? '',
      developer: data?['developer'] ?? '',
      description: data?['description'] ?? '',
      urlimage: data?['urlimage'] ?? '',
      year: data?['year'] ?? 0,
    );
  }
}
