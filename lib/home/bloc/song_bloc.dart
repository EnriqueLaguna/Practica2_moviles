import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart'as http;
import 'package:practica2_moviles/utils/secrets.dart';
import 'package:record/record.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {

  SongBloc() : super(SongInitial()) {
    on<OnListenToSong>(_recordSong);
  }


  //Funcion para grabar
  FutureOr<void> _recordSong(OnListenToSong event, Emitter emit) async {
      try{
        //Funcion para grabar el audio
        final record = Record();
        //Pedir permiso para grabar
        final permission = await record.hasPermission();
        if(!permission){
          emit(SongErrorState());
          return;
        }
        //Empezar a grabar
        await record.start();

        //Esperar para que se grabe
        await Future.delayed(
          Duration(seconds: 10)
        );

        //Terminar de grabar
        String? _listedSongPath = await record.stop();

        //Verificar si se grabo algo
        if(_listedSongPath == null){
          emit(SongErrorState());
          return;
        }

        File _sendFile = new File(_listedSongPath);

        String _fileAsBytes = base64Encode(_sendFile.readAsBytesSync());

        final informacionDeRespuesta = await _getSongInfo(_fileAsBytes);

        final info = {
          "artist": informacionDeRespuesta["artist"],
          "title": informacionDeRespuesta["title"],
          "album": informacionDeRespuesta["album"],
          "release_date": informacionDeRespuesta["release_date"],
          "apple_music": informacionDeRespuesta["apple_music"], //== null? "Lo que quiera": informacionDeRespuesta["apple_music"]["url"],
          "spotify": informacionDeRespuesta["spotify"]["external_urls"]["spotify"],
          "song_link": informacionDeRespuesta["song_link"],
          "albumImage": informacionDeRespuesta["spotify"]["album"]["images"][0]["url"],
        };

        //print(info);
        emit(SongSuccessState(songInfoJson: info));


      }catch(e){
        print(e);
      }
  
  }

  //Obtener la infomracion de la cancion de la API
  Future<dynamic> _getSongInfo(String _filesAsBytes) async {
    //Informacion necesaria para la API
    final Uri urlDeLaAPI = Uri.parse("https://api.audd.io/");
    Map<String, String> urlParameters = {
      'api_token': API_TOKEN,
      'audio': _filesAsBytes,
      'return': 'apple_music,spotify',
    };
    try{
      final response = await http.post(urlDeLaAPI, body: urlParameters);
      if(response.statusCode == 200){
        return jsonDecode(response.body)["result"];
      }
    }catch(e){

    }
  }

}
