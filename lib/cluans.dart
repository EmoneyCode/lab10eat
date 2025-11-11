// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class CluanModel extends ChangeNotifier {
  SupabaseClient supabaseClient = Supabase.instance.client;

  List<Cluan> _cluans = [];

  List<Cluan> get cluanContent => _cluans;

  int get numCluans => _cluans.length;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool val){
    _isLoggedIn = val;
    getAllCluans();
  }
  // void insert() async{
  //   for(var cluan in _cluans){
  //     await supabaseClient.from('cluans').insert(cluan.toJson());
  //   }
  // }



  void getAllCluans() async{
    List<Map<String,dynamic>> result = await supabaseClient.from('cluans').select();
    _cluans.clear();
    for(Map<String, dynamic> row in result){
      _cluans.add(Cluan.fromMap(row));
    }
    notifyListeners();
  }

  void remove(Cluan cluan) async{
    await supabaseClient.from('cluans').delete().eq('id', cluan.id);
    getAllCluans();
  }

  void sortByClue() {
    _cluans.sort((a, b) => a.clue.toString().compareTo(b.clue.toString()));
    notifyListeners();
  }

  void sortByAnswer() {
    _cluans.sort((a, b) => a.answer.length.compareTo(b.answer.length));
    notifyListeners();
  }

  void addCluan(String clue, String answer, DateTime created_at) async{
    String user_id = supabaseClient.auth.currentUser!.id;
    Cluan newCluan = Cluan(clue: clue, answer: answer, created_at: created_at, user_id: user_id);
    await supabaseClient.from("cluans").insert(newCluan.toJson());
    getAllCluans();
  }
  Map<String, double> getAnswerLengthStats() {
    if (_cluans.isEmpty) {
      return {
        'min': 0,
        'max': 0,
        'mean': 0,
        'stdDev': 0,
      };
    }

    // List of answer lengths
    List<int> lengths = _cluans.map((c) => c.answer!.length).toList();

    double minLen = lengths.reduce(min).toDouble();
    double maxLen = lengths.reduce(max).toDouble();
    double mean = lengths.reduce((a, b) => a + b) / lengths.length;

    // Sample standard deviation (divide by n-1)
    double variance = 0;
    if (lengths.length > 1) {
      variance = lengths
              .map((len) => pow(len - mean, 2))
              .reduce((a, b) => a + b) /
          (lengths.length - 1);
    }
    double stdDev = sqrt(variance);

    // Round to 1 decimal place
    return {
      'min': double.parse(minLen.toStringAsFixed(1)),
      'max': double.parse(maxLen.toStringAsFixed(1)),
      'mean': double.parse(mean.toStringAsFixed(1)),
      'stdDev': double.parse(stdDev.toStringAsFixed(1)),
    };
  }

  Cluan getLongestAnswer() {
    if (_cluans.isEmpty) throw StateError('No cluans available');
    Cluan longest = _cluans.first;
    for (var c in _cluans) {
      if (c.answer!.length > longest.answer!.length) {
        longest = c;
      }
    }
    return longest;
  }

  Cluan getShortestAnswer() {
    if (_cluans.isEmpty) throw StateError('No cluans available');
    Cluan shortest = _cluans.first;
    for (var c in _cluans) {
      if (c.answer!.length < shortest.answer!.length) {
        shortest = c;
      }
    }
    return shortest;
  }
}

class Cluan {
  final int id;
  final String clue;
  final String answer;
  final DateTime created_at;
  final String user_id;

  static const int maxClueLength = 150;
  static const int maxAnswerLength = 21;

  Cluan({this.id = 0, required this.clue, required this.answer, required this.created_at, required this.user_id}) {
    if (clue.length > maxClueLength) {
      throw ArgumentError("Too big of a clue");
    }

    if (answer.length > maxAnswerLength) {
      throw ArgumentError("Too big of an answer");
    }
  }

  factory Cluan.fromMap(Map<String, dynamic> row){
    return Cluan(
      id: row["id"],
      clue: row["clue"],
      answer: row["answer"],
      created_at: DateTime.parse(row["created_at"]),
      user_id: row['user_id']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'clue' : clue,
      'answer' : answer,
      'created_at' : created_at.toIso8601String(),
      'user_id' : user_id
    };
  }


}
