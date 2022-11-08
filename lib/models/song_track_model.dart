class SongTrackModel {
  final String name;
  final String? imageUrl;
  final String album;
  final String date;
  final String artist;
  final String? spotifyUrl;
  final String? appleUrl;
  final String? trackId;
  final String listenUrl;

  SongTrackModel({
    required this.spotifyUrl,
    required this.appleUrl,
    required this.listenUrl,
    required this.name,
    required this.imageUrl,
    required this.album,
    required this.date,
    required this.artist,
  }) : trackId = name + artist + album + date;

  SongTrackModel.fromMap(Map<String, dynamic> item)
      : spotifyUrl = item["spotifyUrl"],
        appleUrl = item["appleUrl"],
        listenUrl = item["listenUrl"],
        name = item["name"] ?? 'No name',
        imageUrl = item["imageUrl"],
        album = item["album"] ?? 'No album',
        date = item["date"] ?? 'No date',
        trackId = item["trackId"] ?? 'No trackId',
        artist = item["artist"] ?? 'No artist';

  Map<String, String?> toMap() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "album": album,
      "date": date,
      "artist": artist,
      "spotifyUrl": spotifyUrl,
      "appleUrl": appleUrl,
      "listenUrl": listenUrl,
      "trackId": trackId,
    };
  }
}
