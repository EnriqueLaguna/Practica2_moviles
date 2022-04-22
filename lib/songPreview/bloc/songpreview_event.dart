part of 'songpreview_bloc.dart';

abstract class SongpreviewEvent extends Equatable {
  const SongpreviewEvent();

  @override
  List<Object> get props => [];
}

class OnAddSongToFavorites extends SongpreviewEvent{
  final Map<String, dynamic> infoAboutSong;

  OnAddSongToFavorites({required this.infoAboutSong});

  @override
  List<Object> get props => [infoAboutSong];
}