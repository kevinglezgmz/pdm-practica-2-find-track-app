import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:practica_2_kevin_gonzalez/blocs/favorite_tracks_bloc/favorite_tracks_repository.dart';
import 'package:practica_2_kevin_gonzalez/models/song_track_model.dart';

part 'favorite_tracks_event.dart';
part 'favorite_tracks_state.dart';

class FavoriteTracksBloc
    extends Bloc<FavoriteTracksEvent, FavoriteTracksState> {
  final FavoriteTracksRepository _tracksRepository;
  final List<SongTrackModel> _currentTracks = [];

  FavoriteTracksBloc({required FavoriteTracksRepository tracksRepository})
      : _tracksRepository = tracksRepository,
        super(FavoriteTracksInitial()) {
    on<FavoriteTracksLoadTracksEvent>(_loadFavoriteTracksEventHandler);
    on<FavoriteTracksAddTrackEvent>(_addTrackEventHandler);
    on<FavoriteTracksRemoveTrackEvent>(_removeTrackEventHandler);
    on<FavoriteTracksResetTracksEvent>(_resetTracksEventHandler);
  }

  FutureOr<void> _loadFavoriteTracksEventHandler(
      FavoriteTracksLoadTracksEvent event,
      Emitter<FavoriteTracksState> emit) async {
    emit(FavoriteTracksProcessingTrackState(tracks: _currentTracks));
    List<SongTrackModel>? currentTracks =
        await _tracksRepository.getUserTracks();
    _currentTracks
      ..clear()
      ..addAll(currentTracks ?? []);
    emit(FavoriteTracksLoadedTracksState(tracks: _currentTracks));
  }

  FutureOr<void> _addTrackEventHandler(FavoriteTracksAddTrackEvent event,
      Emitter<FavoriteTracksState> emit) async {
    emit(FavoriteTracksProcessingTrackState(tracks: _currentTracks));
    try {
      final status = await _tracksRepository.addFavoriteTrack(event.track);
      if (status == AddTrackStatus.addedToFavs) {
        _currentTracks.add(event.track);
      }
      emit(FavoriteTracksAddSuccessTrackState(status: status));
    } catch (e) {
      emit(FavoriteTracksAddErrorTrackState());
    } finally {
      emit(FavoriteTracksLoadedTracksState(tracks: _currentTracks));
    }
  }

  FutureOr<void> _removeTrackEventHandler(FavoriteTracksRemoveTrackEvent event,
      Emitter<FavoriteTracksState> emit) async {
    emit(FavoriteTracksProcessingTrackState(tracks: _currentTracks));
    try {
      final status = await _tracksRepository.removeFavoriteTrack(event.track);
      if (status == RemoveTrackStatus.removedFromFavs) {
        _currentTracks
            .removeWhere((element) => element.trackId == event.track.trackId);
      } else if (status == RemoveTrackStatus.errorRemovingFav) {
        throw status;
      }
      emit(FavoriteTracksRemoveSuccessTrackState());
    } catch (e) {
      emit(FavoriteTracksRemoveErrorTrackState());
    } finally {
      emit(FavoriteTracksLoadedTracksState(tracks: _currentTracks));
    }
  }

  void _resetTracksEventHandler(
      FavoriteTracksResetTracksEvent event, Emitter<FavoriteTracksState> emit) {
    _currentTracks.clear();
    emit(FavoriteTracksInitial());
  }
}
