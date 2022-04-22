part of 'song_bloc.dart';

abstract class SongState extends Equatable {
  const SongState();
  
  @override
  List<Object> get props => [];
}

class SongInitial extends SongState {}

class SongErrorState extends SongState {}

class SongLoadingState extends SongState {}

class SongInfoReceivedState extends SongState{
}

class SongSuccessState extends SongState{
  final Map<String, dynamic> songInfoJson;

  SongSuccessState({required this.songInfoJson});

  @override
  List<Object> get props => [songInfoJson];
}
