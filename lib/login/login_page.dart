import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/auth/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Sign In", 
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),
      body: Stack(
        children: [
            Container(
            decoration: BoxDecoration(
              image:  DecorationImage(
                image: AssetImage("assets/backgroundMusic.gif"),
                fit: BoxFit.cover,
              )
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //El icono de la pinche aplicacion
              Center(
                child: Container(
                  child: Image(
                    image: AssetImage("assets/musica.png"),
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              SizedBox(height: 155,),
              //El boton de inicio con Google
              Center(
                child: MaterialButton(
                  hoverColor: Color.fromARGB(255, 17, 61, 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.g_mobiledata_outlined, color: Colors.white, size: 40,),
                      SizedBox(width: 20,),
                      Text("Iniciar con Google", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  color: Colors.green,
                  minWidth: MediaQuery.of(context).size.width - 30,
                  onPressed: (){
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  }
                ),
              ),
            ],
          )
        ]
      ),
    );
  }
}