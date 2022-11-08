part of 'favorite_tracks_bloc.dart';

abstract class FavoriteTracksState extends Equatable {
  const FavoriteTracksState();

  @override
  List<Object> get props => [];
}

class FavoriteTracksInitial extends FavoriteTracksState {}

class FavoriteTracksAddedTrackState extends FavoriteTracksState {
  final List<SongTrackModel> tracks;

  const FavoriteTracksAddedTrackState({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class FavoriteTracksRemovedTrackState extends FavoriteTracksState {
  final List<SongTrackModel> tracks;

  const FavoriteTracksRemovedTrackState({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class FavoriteTracksLoadedTracksState extends FavoriteTracksState {
  final List<SongTrackModel> tracks;

  const FavoriteTracksLoadedTracksState({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class FavoriteTracksProcessingTrackState extends FavoriteTracksState {
  final List<SongTrackModel> tracks;

  const FavoriteTracksProcessingTrackState({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class FavoriteTracksAddErrorTrackState extends FavoriteTracksState {}

class FavoriteTracksAddSuccessTrackState extends FavoriteTracksState {
  final AddTrackStatus status;
  const FavoriteTracksAddSuccessTrackState({required this.status});
  @override
  List<Object> get props => [status];
}

class FavoriteTracksRemoveErrorTrackState extends FavoriteTracksState {}

class FavoriteTracksRemoveSuccessTrackState extends FavoriteTracksState {}
