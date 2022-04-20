part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();
  
  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongSuccessState extends SongState {}

class SongErrorState extends SongState {}

class SongLoadingState extends SongState {}

class SongListeningState extends SongState{}

class SongFileChangedState extends SongState{
  final File songFile;

  SongFileChangedState({required this.songFile});

  @override
  List<Object> get props => [songFile];
}