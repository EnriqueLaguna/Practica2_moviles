part of 'songpreview_bloc.dart';

abstract class SongpreviewState extends Equatable {
  const SongpreviewState();
  
  @override
  List<Object> get props => [];
}

class SongpreviewInitial extends SongpreviewState {}

//Si se guardo en firebase
class SongpreviewSuccessState extends SongpreviewState{}

//Si no se guardo en firebase
class SongpreviewErrorState extends SongpreviewState{}

//Error state y por si la cacion ya existe
class SongprevieUploadingState extends SongpreviewState{}

