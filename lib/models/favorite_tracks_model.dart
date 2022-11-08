import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteTrackModel {
  final DocumentReference<Map<String, dynamic>> user;
  final DocumentReference<Map<String, dynamic>> track;

  FavoriteTrackModel({
    required this.track,
    required this.user,
  });

  FavoriteTrackModel.fromMap(Map<String, dynamic> item)
      : track = item['track'],
        user = item['user'];
}
