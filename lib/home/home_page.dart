import 'dart:io';

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/auth/bloc/auth_bloc.dart';
import 'package:practica2_moviles/favorites/favorites_page.dart';
import 'package:practica2_moviles/home/bloc/song_bloc.dart';

import 'package:record/record.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Animacion del boton
  bool _animate = false;
  bool _isRecording = false;

  //Grabado de audio
  final record = Record();

  //Archivo para mandar al Bloc
  File? songFile;

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await record.hasPermission()) {
        await record.start();

        bool isRecording = await record.isRecording();
        setState(() {
          _isRecording = isRecording;
          _animate = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    final path = await record.stop();

    songFile = File(path!);

    setState(() {
      _isRecording = false;
      _animate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongBloc, SongState>(
      listener: (context, state) {
        if(state is SongErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error con la cancion"))
          );
        }else if (state is SongListeningState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Escuchando la cancion"))
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
                            // _isRecording ? await _stop() : await _start();
                            // if (!_isRecording) {
                            //   print(songFile!.path);
                            //   Map<String, dynamic> songDataHomePage = {"file": songFile};
                            //   BlocProvider.of<SongBloc>(context).add(OnSendSongFile(songFileToSave: songDataHomePage));
                            // }
                            BlocProvider.of<SongBloc>(context).add(OnListenToSong());
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Favorites()));
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
                        BlocProvider.of<SongBloc>(context).add(LoadSongInfo());
                      },
                      icon: CircleAvatar(
                        child: Icon(Icons.music_off),
                        backgroundColor: Colors.white54,
                        foregroundColor: Colors.black54,
                      ),
                      iconSize: 40,
                      tooltip: "Test Song info",
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context)..add(SignOutEvent());
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
