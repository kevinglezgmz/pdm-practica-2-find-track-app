part of 'favorite_tracks_bloc.dart';

abstract class FavoriteTracksEvent extends Equatable {
  const FavoriteTracksEvent();

  @override
  List<Object> get props => [];
}

class FavoriteTracksLoadTracksEvent extends FavoriteTracksEvent {}

class FavoriteTracksResetTracksEvent extends FavoriteTracksEvent {}

class FavoriteTracksAddTrackEvent extends FavoriteTracksEvent {
  final SongTrackModel track;

  const FavoriteTracksAddTrackEvent({required this.track});

  @override
  List<Object> get props => [track];
}

class FavoriteTracksRemoveTrackEvent extends FavoriteTracksEvent {
  final SongTrackModel track;

  const FavoriteTracksRemoveTrackEvent({required this.track});

  @override
  List<Object> get props => [track];
}
