import 'dart:io';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/auth/bloc/auth_bloc.dart';
import 'package:practica2_moviles/favorites/bloc/favorites_bloc.dart';
import 'package:practica2_moviles/favorites/favorites_page.dart';
import 'package:practica2_moviles/home/bloc/song_bloc.dart';
import 'package:practica2_moviles/songPreview/song_preview.dart';

import 'package:record/record.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Animacion del boton
  bool _animate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        if(state is SongErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error con la cancion"))
          );
        }else if(state is SongSuccessState){
          setState(() {
            _animate = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongPreview(songInfo: state.songInfoJson)
            )
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 70, 70, 70),
          body: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  "Toque para escuchar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: AvatarGlow(
                    glowColor: Colors.redAccent,
                    endRadius: 120,
                    animate: _animate,
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<SongBloc>(context).add(OnListenToSong());
                            setState(() {
                              _animate = true;
                            });
                          },
                          child: Image(
                            image: AssetImage("assets/musica.png"),
                          ),
                        ),
                        radius: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<FavoritesBloc>(context).add(OnGetUserFavorites());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Favorites()
                          )
                        );
                      },
                      icon: CircleAvatar(
                        child: Icon(Icons.favorite),
                        backgroundColor: Colors.white54,
                        foregroundColor: Colors.black54,
                      ),
                      iconSize: 40,
                      tooltip: "Favoritos",
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(context: context, builder: (builder) => AlertDialog(
                            title: Text("Cerrar sesión"),
                            content: Text("Al cerrar sesión de su cuenta será redirigido a la pantalla de Log in, ¿Quiere continuar?"),
                            actions: [
                              TextButton(
                                child: Text("Cancelar"), 
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Cerrar sesión"), 
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  BlocProvider.of<AuthBloc>(context)..add(SignOutEvent());
                                },
                              ),
                            ],
                          ),
                        );
                        
                      },
                      icon: CircleAvatar(
                        child: Icon(Icons.power_settings_new),
                        backgroundColor: Colors.white54,
                        foregroundColor: Colors.black54,
                      ),
                      iconSize: 40,
                      tooltip: "Salir",
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
