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
import 'package:flutter_demo_29_september/statistics.dart';
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
    return MaterialApp(home: HomeScreen(context.read<CluanModel>()));
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen(CluanModel cluanModel, {super.key}) {
    cluanModel.getAllCluans();
  }
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> listOfWids = [
    ListViewPlayground(),
    AddCluans(),
    const StatsScreen(),
  ];

  void ontapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<CluanModel>().sortByClue();
            },
            icon: const Icon(Icons.sort_by_alpha),
          ),
          IconButton(
            onPressed: () {
              context.read<CluanModel>().sortByAnswer();
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text("Cluans"),
      ),
      body: listOfWids[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: ontapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Cluan'),
          BottomNavigationBarItem(icon: Icon(Icons.line_axis), label: 'Stats'),
        ],
      ),
    );
  }
}

class ListViewPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cluans = context.watch<CluanModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: Colors.white, thickness: 1.0),
            itemCount: cluans.cluanContent.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                cluans.cluanContent[index].clue!,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                cluans.cluanContent[index].answer!,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Text(
                cluans.cluanContent[index].created_at.toString()!.split(' ')[0],
              ),
              onLongPress: () => cluans.remove(cluans.cluanContent.elementAt(index)),
            ),
          ),
        ),
      ),
    );
  }
}
