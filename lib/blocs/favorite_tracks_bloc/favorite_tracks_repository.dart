import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practica_2_kevin_gonzalez/models/collections.dart';
import 'package:practica_2_kevin_gonzalez/models/favorite_tracks_model.dart';
import 'package:practica_2_kevin_gonzalez/models/song_track_model.dart';

enum AddTrackStatus {
  addedToFavs,
  errorAddingToFav,
  alreadyFaved,
}

enum RemoveTrackStatus {
  removedFromFavs,
  errorRemovingFav,
}

class FavoriteTracksRepository {
  final favoriteTracksCollection =
      FirebaseFirestore.instance.collection(COLLECTIONS.favoriteTracks);
  final usersCollection =
      FirebaseFirestore.instance.collection(COLLECTIONS.users);
  final tracksCollection =
      FirebaseFirestore.instance.collection(COLLECTIONS.tracks);

  Future<List<SongTrackModel>?> getUserTracks() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    final userRef = usersCollection.doc(uid);
    final favoriteTracks =
        await favoriteTracksCollection.where('user', isEqualTo: userRef).get();
    final tracksRefs = favoriteTracks.docs
        .map((doc) => FavoriteTrackModel.fromMap(doc.data()))
        .toList();
    final tracksDocs = await Future.wait(
        tracksRefs.map((favTrack) => favTrack.track.get()).toList());
    return tracksDocs
        .map((track) => SongTrackModel.fromMap(track.data()!))
        .toList();
  }

  Future<AddTrackStatus> addFavoriteTrack(SongTrackModel track) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return AddTrackStatus.errorAddingToFav;
    }
    final userRef = usersCollection.doc(uid);
    final tracksInDb =
        await tracksCollection.where("trackId", isEqualTo: track.trackId).get();

    final DocumentReference<Map<String, dynamic>> trackRef;
    if (tracksInDb.docs.isEmpty) {
      trackRef = await tracksCollection
          .add(track.toMap()..addAll({"trackId": track.trackId}));
    } else {
      trackRef = tracksInDb.docs.first.reference;
    }

    // Track is now in db, check if user has it
    final maybeFavTrack = await favoriteTracksCollection
        .where("user", isEqualTo: userRef)
        .where("track", isEqualTo: trackRef)
        .get();
    if (maybeFavTrack.docs.isNotEmpty) {
      // User has this track, nothing to do
      return AddTrackStatus.alreadyFaved;
    }

    // User does not have the track, add it
    await favoriteTracksCollection.add({"user": userRef, "track": trackRef});
    return AddTrackStatus.addedToFavs;
  }

  Future<RemoveTrackStatus> removeFavoriteTrack(SongTrackModel track) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return RemoveTrackStatus.errorRemovingFav;
    }
    final userRef = usersCollection.doc(uid);
    final trackInDb =
        await tracksCollection.where("trackId", isEqualTo: track.trackId).get();
    if (trackInDb.docs.isNotEmpty) {
      final maybeFavTrackRef = trackInDb.docs.first.reference;
      // Track in db, check if user has it
      final maybeFavTrack = await favoriteTracksCollection
          .where("user", isEqualTo: userRef)
          .where("track", isEqualTo: maybeFavTrackRef)
          .get();
      if (maybeFavTrack.docs.isNotEmpty) {
        await maybeFavTrack.docs.first.reference.delete();
        // Successfuly removed the track from favorites
        return RemoveTrackStatus.removedFromFavs;
      }
    }
    return RemoveTrackStatus.errorRemovingFav;
  }
}
