// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_2_kevin_gonzalez/blocs/favorite_tracks_bloc/favorite_tracks_bloc.dart';
import 'package:practica_2_kevin_gonzalez/models/song_track_model.dart';
import 'package:practica_2_kevin_gonzalez/pages/favorite_tracks_page/song_track_tile.dart';

class FavoriteTracksPage extends StatelessWidget {
  const FavoriteTracksPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Canciones favoritas'),
      ),
      body: BlocConsumer<FavoriteTracksBloc, FavoriteTracksState>(
        listener: (context, state) {
          if (state is FavoriteTracksProcessingTrackState) {
            _showSnackBar(context, "Eliminando canción de favoritos...");
          } else if (state is FavoriteTracksRemoveSuccessTrackState) {
            _showSnackBar(context, "¡Canción eliminada de favoritos!");
          }
        },
        builder: (context, state) {
          if (state is FavoriteTracksAddedTrackState) {
            return _tracksList(state.tracks);
          } else if (state is FavoriteTracksRemovedTrackState) {
            return _tracksList(state.tracks);
          } else if (state is FavoriteTracksLoadedTracksState) {
            return _tracksList(state.tracks);
          } else if (state is FavoriteTracksProcessingTrackState) {
            return _tracksList(state.tracks);
          }
          return Text("No tracks");
        },
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

  Widget _tracksList(List<SongTrackModel> tracks) {
    if (tracks.isEmpty) {
      return Center(
        child: Text("No tienes ninguna canción guardada!"),
      );
    }
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (BuildContext context, int index) {
        return SongTrackTile(
          track: tracks[index],
        );
      },
    );
  }
}
