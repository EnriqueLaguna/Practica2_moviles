import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/favorites/bloc/favorites_bloc.dart';
import 'package:practica2_moviles/favorites/favoritesItem.dart';

class Favorites extends StatefulWidget {

  Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state){
          
        },
        builder: (context, state) {
          if(state is FavoritesSuccessState){
            return Scaffold(
              appBar: AppBar(),
              body: ListView.builder(
                itemCount: state.userFavoritesSongs.length,
                itemBuilder: (BuildContext context, int index){
                  return FavoritesItem(songInfo: state.userFavoritesSongs[index]);
                }
              ),
            );
          }else if(state is FavoritesLoadingState){
            return Center(child: CircularProgressIndicator());
          }else {
            return Center(child: Text("Muerte"));
          }
          
          
        }
      );
  }
}