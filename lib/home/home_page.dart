import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/auth/bloc/auth_bloc.dart';
import 'package:practica2_moviles/favorites/favorites_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _animate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 70, 70, 70),
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text("Toque para escuchar",style: TextStyle(color: Colors.white, fontSize: 20),)
            ),
            SizedBox(height: 50,),
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
                      onPressed: (){
                        setState(() {
                          _animate = true;
                        });
                      },
                      child: Image(
                        image: AssetImage("assets/musica.png"),
                      ),
                    ),
                    radius:80,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                IconButton(
                  onPressed:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Favorites())
                    );
                  }, 
                  icon: CircleAvatar(child: Icon(Icons.favorite), backgroundColor: Colors.white54, foregroundColor: Colors.black54,),
                  iconSize: 40,
                  tooltip: "Favoritos",
                ),
                IconButton(
                  onPressed:(){
                    BlocProvider.of<AuthBloc>(context)..add(SignOutEvent());
                  }, 
                  icon: CircleAvatar(child: Icon(Icons.power_settings_new), backgroundColor: Colors.white54, foregroundColor: Colors.black54,),
                  iconSize: 40,
                  tooltip: "Salir",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}