part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class OnGetUserFavorites extends FavoritesEvent{}

class OnDeleteSelectedSong extends FavoritesEvent{
  final Map<String, dynamic> toDeleteSongInfo;

  OnDeleteSelectedSong({required this.toDeleteSongInfo});

  @override
  List<Object> get props => [toDeleteSongInfo];
}