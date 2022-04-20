part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class OnSendSongFile extends SongEvent{
  final Map<String, dynamic> songFileToSave;

  OnSendSongFile({required this.songFileToSave});

  @override
  List<Object> get props => [songFileToSave];
}

class OnPruebaSongAPI extends SongEvent{}

class LoadSongInfo extends SongEvent{}

class OnListenToSong extends SongEvent{}
