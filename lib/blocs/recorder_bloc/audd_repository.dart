import 'dart:convert';

import 'package:http/http.dart';
import 'package:practica_2_kevin_gonzalez/models/song_track_model.dart';
import 'package:practica_2_kevin_gonzalez/secrets.dart';

class AudDRepository {
  final Uri _url = Uri.parse('https://api.audd.io/');

  Future<SongTrackModel?> analyzeAudioFromPath(String pathToFile) async {
    Map<String, String> requestBody = {
      'api_token': API_KEY,
      'return': 'apple_music,spotify',
    };
    MultipartFile multipartFile =
        await MultipartFile.fromPath('file', pathToFile);
    MultipartRequest request = MultipartRequest('POST', _url)
      ..fields.addAll(requestBody)
      ..files.add(multipartFile);
    StreamedResponse response = await request.send();
    final Response parsedResponse = await Response.fromStream(response);
    if (parsedResponse.statusCode != 200) {
      return null;
    }
    dynamic parsedBody = jsonDecode(parsedResponse.body);
    if (parsedBody['status'] != 'success' || parsedBody['result'] == null) {
      return null;
    }
    dynamic result = parsedBody['result'];
    dynamic apple = result['apple_music'];
    dynamic spotify = result['spotify'];
    spotify?.remove('available_markets');
    spotify?['album'].remove('available_markets');
    spotify?['album'].remove('album_type');
    spotify?['album'].remove('artists');
    spotify?['album'].remove('href');
    apple?.remove('previews');
    apple?.remove('artwork');
    result.remove('apple_music');
    result.remove('spotify');
    return SongTrackModel(
      name: result['title'],
      imageUrl: spotify?['album']?['images']?[0]?['url'],
      album: result['album'],
      date: result['release_date'],
      artist: result['artist'],
      spotifyUrl: spotify?['external_urls']?['spotify'],
      appleUrl: apple?['url'],
      listenUrl: result['song_link'],
    );
  }
}
