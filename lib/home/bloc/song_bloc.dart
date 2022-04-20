import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:record/record.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {

  File? _listedSongFile;
  bool _isRecording = false;

  SongBloc() : super(SongInitial()) {
    on<OnListenToSong>(_getSongData);
    on<LoadSongInfo>(loadSongInfo);
    on<OnSendSongFile>(_saveData);
  }

  final String urlDeLaAPI = "https://api.audd.io/";

  Map<String, String> weaRaraQueNoEntiendo = {
    'api_token': '',
    'url': 'https://audd.tech/example.mp3',
    'return': 'apple_music, spotify'
  };

  Future<void> _saveData(OnSendSongFile event, Emitter emit) async {
    emit(SongLoadingState());

    File songFileBitch = event.songFileToSave["file"];

    Map<String, dynamic> weaRaraConElArchivo = {
      'api_token': 'd772e1a104c428aa006aba020829eab3',
      'file': songFileBitch.readAsBytesSync(),
      'return': 'apple_music, spotify'
    };

    final Uri url = Uri.https('api.audd.io', '/', weaRaraConElArchivo);
    print(url);

    try{
      Response res = await get(url);
      if(res.statusCode == HttpStatus.ok){
        print(jsonDecode(res.body));
      }
    } catch (e){
      print(e);
    }

  }

  void loadSongInfo(LoadSongInfo event, Emitter emit) async {
    emit(SongLoadingState());
    var songInfo = await _getSongFromApi();
    if(songInfo == null){
      emit(SongErrorState());
    } else {
      print(songInfo);
      emit(SongSuccessState());
    }
  }

  Future _getSongFromApi() async {
    final Uri url = Uri.https('api.audd.io', '/', weaRaraQueNoEntiendo);
    print(url);

    try{
      Response res = await get(url);
      if(res.statusCode == HttpStatus.ok){
        return jsonDecode(res.body);
      }
    } catch (e){
      print(e);
    }
  }
  FutureOr<void> _getSongData(OnListenToSong event, Emitter emit) async {
      emit(SongListeningState());
      await _listenToSong();
      if(_listedSongFile == null){
        emit(SongErrorState());
      } else {
        Map<String, dynamic> weaRaraConElArchivo = {
          'api_token': '',
          'file': _listedSongFile!.readAsBytesSync(),
          'return': 'apple_music, spotify'
        };

        final Uri url = Uri.https('api.audd.io', '/', weaRaraConElArchivo);
        print(url);

        try{
          Response res = await get(url);
          if(res.statusCode == HttpStatus.ok){
            print(jsonDecode(res.body));
          }
        } catch (e){
          print(e);
        }
      }
    }

    Future<void> _listenToSong() async {
      final record = Record();
      final permissionBro = await record.hasPermission();
      if(permissionBro){
        await record.start();
        _isRecording = await record.isRecording();
        if(!_isRecording){
          final songPathBro = await record.stop();
          _listedSongFile = File(songPathBro!);
        }
      }else{
        print("No se dieron los permisos");
      }
    }
}
