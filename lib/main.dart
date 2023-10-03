import 'dart:async';
import 'package:assignment/screens/AddJob/Addjob.dart';

import 'package:assignment/screens/Login/bloc/Login_bloc.dart';
import 'package:assignment/screens/nav/bloc/incidents_bloc.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:assignment/screens/Login/Login.dart';
import 'package:provider/provider.dart';
import 'package:assignment/screens/AddJob/Addjob.dart';
import 'package:cbl/cbl.dart';


Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<LoginBloc>(create: (context)=>LoginBloc()),
          Provider<IncidentsBloc>(create: (context)=>IncidentsBloc())
        ],
      child:MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}):super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  void initState(){
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=> Login(),),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 64, 110),
      body: SingleChildScrollView(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/247logo.png"))
          ],
        ),
      ))

    );
  }
}


