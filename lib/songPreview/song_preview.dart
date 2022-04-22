import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/songPreview/bloc/songpreview_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPreview extends StatefulWidget {
  final Map<String, dynamic> songInfo;

  SongPreview({Key? key, required this.songInfo}) : super(key: key);

  @override
  State<SongPreview> createState() => _SongPreviewState();
}

class _SongPreviewState extends State<SongPreview> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongpreviewBloc, SongpreviewState>(
      listener: (context, state) {
        if(state is SongprevieUploadingState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Procesando...", style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            )
          );
        }else if(state is SongpreviewSuccessState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Agregando a favoritos...", style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            )
          );
        } else if(state is SongpreviewErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Ya existe la cancion en favoritos..."),
              backgroundColor: Color.fromARGB(255, 214, 95, 87),
            )
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Here you go"),
              actions: [
                IconButton(
                    onPressed: () {
                      //Agregar cancion a lista de favoritos de usuario
                      //Usar bloc de SongPreview
                      showDialog(context: context, builder: (builder) => AlertDialog(
                        title: Text("Agregar a favoritos"),
                        content: Text("El elemento será agregado a tus favoritos\n ¿Quieres continuar"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, 
                            child: Text("Cancelar")
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              BlocProvider.of<SongpreviewBloc>(context).add(OnAddSongToFavorites(infoAboutSong: widget.songInfo));
                            }, 
                            child: Text("Continuar")
                          )
                        ],
                      ));
                    },
                    icon: Icon(Icons.favorite))
              ],
            ),
            backgroundColor: Color.fromARGB(255, 70, 70, 70),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                      Image.network(widget.songInfo["albumImage"].toString()),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.songInfo["title"].toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.songInfo["album"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.songInfo["artist"].toString(),
                  style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                ),
                Text(
                  widget.songInfo["release_date"].toString(),
                  style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Color.fromARGB(255, 112, 111, 111),
                ),
                Text("Abrir con"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                        onPressed: () {
                          launch(widget.songInfo["spotify"].toString());
                        },
                        child: Tooltip(
                          message: "Abrir con Spotify",
                          child: Image.asset("assets/spotify.png"))),
                    MaterialButton(
                        onPressed: () {
                          launch(widget.songInfo["song_link"].toString());
                        },
                        child: Tooltip(
                          message: "Abrir con Dezzer",
                          child: Image.asset(
                            "assets/podcast.png",
                            height: 64,
                            width: 64,
                          ),
                        )),
                    MaterialButton(
                        onPressed: () {
                          if (widget.songInfo["apple_music"] != null) {
                            launch(widget.songInfo["apple_music"]["url"].toString());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("No se encuentra la cancion"),
                              backgroundColor: Colors.purple,
                            ));
                          }
                        },
                        child: Tooltip(
                          message: "Abrir con Apple Music",
                          child: Image.asset(
                            "assets/apple.png",
                            height: 64,
                            width: 64,
                          ),
                        )),
                  ],
                )
              ],
            ));
      },
    );
  }
}
