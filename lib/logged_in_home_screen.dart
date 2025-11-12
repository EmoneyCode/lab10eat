import 'package:flutter/material.dart';
import 'package:flutter_demo_29_september/Listview.dart';
import 'package:flutter_demo_29_september/addCluans.dart';
import 'package:flutter_demo_29_september/cluans.dart';
import 'package:flutter_demo_29_september/statistics.dart';
import 'package:provider/provider.dart';

class LoggedInHomeScreen extends StatefulWidget {
  LoggedInHomeScreen(CluanModel cluanModel, {super.key}) {
    cluanModel.getAllCluans();
  }
  @override
  State<StatefulWidget> createState() {
    return _LoggedInHomeScreenState();
  }
}

class _LoggedInHomeScreenState extends State<LoggedInHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> listOfWids = [];

  void ontapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listOfWids = [
      ListViewPlayground(_selectedIndex),
      ListViewPlayground(_selectedIndex),
      const StatsScreen(),
    ];
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
          IconButton(onPressed: (){
            Navigator.push(context, 
              MaterialPageRoute(builder: (context)=> AddCluans())
            );
          }, 
          icon: const Icon(Icons.add))
        ],
        title: const Text("Cluans"),
      ),
      body: listOfWids[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: ontapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_city), label: 'All Cluans'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'My Cluans'),
          BottomNavigationBarItem(icon: Icon(Icons.line_axis), label: 'Stats'),
        ],
      ),
    );
  }
}