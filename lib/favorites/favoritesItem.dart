import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/favorites/bloc/favorites_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesItem extends StatefulWidget {
  //Informacion de las canciones
  final Map<String, dynamic> songInfo;

  FavoritesItem({Key? key, required this.songInfo}) : super(key: key);

  @override
  State<FavoritesItem> createState() => _FavoritesItemState();
}

class _FavoritesItemState extends State<FavoritesItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: Stack(
          children: [
            GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (builder) => AlertDialog(
                  title: Text("Abrir canción"),
                  content: Text("Será redirigido a ver opciones para abrir la canción ¿Quiere continuar?"),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                      child: Text("Cancelar")
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        launch(widget.songInfo["song_link"]);
                      }, 
                      child: Text("Continuar")
                    ),
                  ],
                ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(25.0)
                ),
                child: Image.network(widget.songInfo["albumImage"]),
                  
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width - 300,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.7),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(24),)
                  ),
                  child: Column(
                    children: [
                      Text(widget.songInfo["title"], style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                      Text(widget.songInfo["artist"], style: TextStyle(color: Colors.white60, fontSize: 15),),
                    ],
                  ),      
                ),
              ),
            ),
            IconButton(
              onPressed: (){
                showDialog(context: context, builder: (builder) => AlertDialog(
                  title: Text("Eliminar de favoritos"),
                  content: Text("El elemento será eliminado de tus favoritos. ¿Quieres continuar?"),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                      child: Text("Cancelar")
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        //Bloc para matar la cancion
                        BlocProvider.of<FavoritesBloc>(context).add(OnDeleteSelectedSong(toDeleteSongInfo: widget.songInfo));
                        BlocProvider.of<FavoritesBloc>(context).add(OnGetUserFavorites());
                      }, 
                      child: Text("Eliminar")
                    ),
                  ],
                ));
              }, 
              icon: Icon(Icons.favorite), 
              color: Colors.white, 
              iconSize: 40.0
            ),
          ],
        ),
      ),
    );
  }
}