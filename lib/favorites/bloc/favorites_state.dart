part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState{}
class FavoritesSuccessState extends FavoritesState{
  final List<dynamic> userFavoritesSongs;

  FavoritesSuccessState({required this.userFavoritesSongs});

  @override
  List<Object> get props => [userFavoritesSongs];
}
class FavoritesErrorState extends FavoritesState{}

class FavoritesDeleteSuccessState extends FavoritesState{}
