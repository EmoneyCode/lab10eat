import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cluans.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cluans = context.watch<CluanModel>();

    final stats = cluans.getAnswerLengthStats();
    final longest = cluans.getLongestAnswer();
    final shortest = cluans.getShortestAnswer();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Answer Length Stats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Min: ${stats['min']}"),
          Text("Max: ${stats['max']}"),
          Text("Mean: ${stats['mean']}"),
          Text("Sample Std Dev: ${stats['stdDev']}"),
          const SizedBox(height: 20),
          Text("Longest Answer: ${longest.answer} (${longest.answer!.length} chars)"),
          Text("Shortest Answer: ${shortest.answer} (${shortest.answer!.length} chars)"),
        ],
      ),
    );
  }
}
