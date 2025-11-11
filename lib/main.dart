// ignore_for_file: dead_code, prefer_conditional_assignment
/*
Ethan Trammell
Lab 9 
October 15th 2025
This is the lab 9 which should help us understand Supabase DB
This one was pretty simple, but the toJson caught me up a bit.
*/
import 'package:flutter/material.dart';
import 'package:flutter_demo_29_september/addCluans.dart';
import 'package:flutter_demo_29_september/logged_in_home_screen.dart';
import 'package:flutter_demo_29_september/statistics.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cluans.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseURL = 'https://gawobzmasqopezwteprg.supabase.co';
  final supabseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdhd29iem1hc3FvcGV6d3RlcHJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NDUxMDcsImV4cCI6MjA3NzMyMTEwN30.aXogy2imAyebSmEvllt2P3yOvL8pbBXqNBZigWHqmCU';
  await Supabase.initialize(url: supabaseURL, anonKey: supabseAnonKey);

  runApp(
    ChangeNotifierProvider(child: MainApp(), create: (context) => CluanModel()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    CluanModel cluanModel = context.watch<CluanModel>();
    if(cluanModel.isLoggedIn){
      return LoggedInHomeScreen(cluanModel);
    }
    else{
      return Scaffold(appBar: AppBar(title: Text('Registration/Login')),
        body: SupaEmailAuth(
          redirectTo: 'edu.uwosh.cluans://login-callback',
          onSignInComplete: (response) {
            cluanModel.isLoggedIn = true;
          },
          onSignUpComplete: onSignUpComplete,
        ),
      );
    }
  }
  void onSignUpComplete(AuthResponse response) {
    print(response);
  }
}