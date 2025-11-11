import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo_29_september/cluans.dart';

class AddCluans extends StatefulWidget {
  const AddCluans({super.key});

  @override
  State<AddCluans> createState() => _AddCluansState();
}

class _AddCluansState extends State<AddCluans> {
  final TextEditingController _clueController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _addCluan(BuildContext context) {
    final clue = _clueController.text.trim();
    final answer = _answerController.text.trim();
    final date = _dateController.text.trim();

    // basic validation
    if (clue.isEmpty || answer.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // optional: check clue/answer length
    if (clue.length > 150 || answer.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clue must be ≤150 chars, Answer ≤50 chars'),
        ),
      );
      return;
    }

    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(date); // expects "YYYY-MM-DD"
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date must be in YYYY-MM-DD format')),
      );
      return;
    }

    // add new Cluan
    context.read<CluanModel>().addCluan(clue, answer, parsedDate);

    // clear fields
    _clueController.clear();
    _answerController.clear();
    _dateController.clear();

    // feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New Cluan added!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cluan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _clueController,
              decoration: const InputDecoration(
                labelText: 'Clue',
                border: OutlineInputBorder(),
              ),
              maxLength: 150,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date (e.g., 2025-10-13)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _addCluan(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Cluan'),
            ),
          ],
        ),
      ),
    );
  }
}
