import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_moviles/auth/bloc/auth_bloc.dart';
import 'package:practica2_moviles/home/bloc/song_bloc.dart';
import 'package:practica2_moviles/home/home_page.dart';
import 'package:practica2_moviles/login/login_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    //poner los bloc necesarios
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        ),
        BlocProvider(
          create: (context) => SongBloc(),
        )
      ], 
      child: MyApp(),
    ),
  );
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.dark()
      ),
      title: 'Material App',
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthErrorState){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error en la autenticación"),
              )
            );
          }
        },
        builder:(context, state) {
          if(state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState || state is AuthErrorState || state is SignOutSuccessState){
            return LoginPage();
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }
        }
      ),
    );
  }
}
