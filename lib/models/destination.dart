import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String description;
  final String locationData;
  final String destinationname;
  final upvotes;
  final String destinationId;
  final DateTime datePublished;


  const Destination({
    required this.description,
    required this.locationData,
    required this.destinationname,
    required this.upvotes,
    required this.destinationId,
    required this.datePublished,
  });

  static Destination fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Destination(
        description: snapshot["description"],
        locationData: snapshot["_locationData"],
        upvotes: snapshot["upvotes"],
        destinationId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        destinationname: snapshot["destinationname"],

    );
  }

  Map<String, dynamic> toJson() =>
      {
        "description": description,
        "locationData": locationData,
        "upvotes": upvotes,
        "destinationname": destinationname,
        "destinationId": destinationId,
        "datePublished": datePublished
      };
}