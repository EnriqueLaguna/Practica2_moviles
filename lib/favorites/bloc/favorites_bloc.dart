import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<OnGetUserFavorites>(_getUserFavoriteSongs);
    on<OnDeleteSelectedSong>(_deleteSelectedSong);
  }

  FutureOr<void> _getUserFavoriteSongs(OnGetUserFavorites event, Emitter emit) async {
    emit(FavoritesLoadingState());
    try{
      
      //Obtener los datos del usuario
      var qUser = await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser!.uid}");

      //El arreglo que esta dentro
      var docsRefs = await qUser.get();
      List<dynamic> listIds = docsRefs.data()?["favoriteSongs"] ?? [];

      //print(listIds);

      //Mandar la informacion
      emit(FavoritesSuccessState(userFavoritesSongs: listIds));


    }catch(e){
      print("Error al obtener las canciones: $e");
      emit(FavoritesErrorState());
    }
  }

  FutureOr<void> _deleteSelectedSong(OnDeleteSelectedSong event, Emitter emit) async {
    try{
      // print(event.toDeleteSongInfo);

      //Obtener la informacion necesaria
      Map<String, dynamic> requiredSongInfo = {
        "title": event.toDeleteSongInfo["title"].toString(),
        "albumImage": event.toDeleteSongInfo["albumImage"].toString(),
        "artist":event.toDeleteSongInfo["artist"].toString(),
        "song_link":event.toDeleteSongInfo["song_link"].toString()
      };

      //Nuevo mapa para subir a firebase
      List<Map<String, dynamic>> newMap = [];

      var qUser = await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser!.uid}")
        .get();

      List<dynamic> allUserSongs = qUser.data()?["favoriteSongs"]; 

      //Revisar si la cancion ya esta en la lista
      for(var song in allUserSongs){
        if(!mapEquals(song, requiredSongInfo)){
          newMap.add(song);
        }
      }

      print(newMap);

      //Borrar el arreglo existente en Firebase
      var qDeleteArray = await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser!.uid}")
        .update({"favoriteSongs": newMap});


      emit(FavoritesSuccessState(userFavoritesSongs: newMap));
    }catch(e){
      print("Error al intentar borrar la cancion: $e");
      return;
    }
  }

}
