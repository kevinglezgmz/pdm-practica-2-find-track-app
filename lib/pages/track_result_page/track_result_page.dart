import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/favorite_tracks_bloc/favorite_tracks_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/favorite_tracks_bloc/favorite_tracks_repository.dart';
import 'package:practica_2_kevin_gonzalez/models/song_track_model.dart';
import 'package:practica_2_kevin_gonzalez/pages/track_result_page/icon_url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrackResultPage extends StatelessWidget {
  final SongTrackModel track;
  const TrackResultPage({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Resultado de la búsqueda'),
        actions: [
          IconButton(
            tooltip: 'Añadir a favoritos',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              _showAddToFavoritesDialog(context);
            },
          )
        ],
      ),
      body: Column(children: [
        _getMainFixedSizedImage(),
        _getSongAlbumTextDetails(),
        const Divider(color: Colors.white),
        _getSongLinkIconButtonsFooter(),
      ]),
    );
  }

  Expanded _getSongLinkIconButtonsFooter() {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Abrir con:',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (track.spotifyUrl != null)
                  IconUrlLauncher(
                    icon: FontAwesomeIcons.spotify,
                    color: Colors.white,
                    url: track.spotifyUrl ?? '',
                    tooltip: 'Ver en Spotify',
                  ),
                IconUrlLauncher(
                  icon: FontAwesomeIcons.podcast,
                  color: Colors.white,
                  url: track.listenUrl,
                  tooltip: 'Ver en Lis.tn',
                ),
                if (track.appleUrl != null)
                  IconUrlLauncher(
                    icon: FontAwesomeIcons.apple,
                    color: Colors.white,
                    url: track.appleUrl ?? '',
                    tooltip: 'Ver en Apple Music',
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded _getSongAlbumTextDetails() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getSingleChildScrollViewText(track.name, 28, FontWeight.bold),
            _getSingleChildScrollViewText(track.album, 24, FontWeight.bold),
            const SizedBox(height: 8),
            _getSingleChildScrollViewText(track.artist, 18, null),
            _getSingleChildScrollViewText(track.date, 16, null),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _getSingleChildScrollViewText(
      String text, double fontSize, FontWeight? fontWeight) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  AspectRatio _getMainFixedSizedImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        width: double.infinity,
        child: Image.network(
          track.imageUrl ?? 'https://i.ibb.co/xMhhc9z/placeholder.png',
          loadingBuilder: ((context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
  }

  _showAddToFavoritesDialog(BuildContext context) {
    showDialog<AddTrackStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Agregar a favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        content: const Text(
          'Esta canción se agregará a tus favoritos. ¿Deseas continuar?',
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          MaterialButton(
            child: const Text('Continuar'),
            onPressed: () {
              BlocProvider.of<FavoriteTracksBloc>(context)
                  .add(FavoriteTracksAddTrackEvent(track: track));
            },
          ),
          BlocListener<FavoriteTracksBloc, FavoriteTracksState>(
            listener: (context, state) {
              if (state is FavoriteTracksAddSuccessTrackState) {
                Navigator.of(context).pop(state.status);
              } else if (state is FavoriteTracksAddErrorTrackState) {
                Navigator.of(context).pop(AddTrackStatus.errorAddingToFav);
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    ).then((value) {
      if (value == AddTrackStatus.addedToFavs) {
        _showSnackBar(context, '¡Se ha agregado la canción a favoritos!');
      } else if (value == AddTrackStatus.alreadyFaved) {
        _showSnackBar(context, '¡La canción ya se encuentra en favoritos!');
      } else if (value == AddTrackStatus.errorAddingToFav) {
        _showSnackBar(context, 'Ha ocurrido un error...');
      }
    });
  }
}
