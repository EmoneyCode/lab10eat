import 'package:flutter/material.dart';
import 'package:flutter_demo_29_september/cluans.dart';
import 'package:provider/provider.dart';

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
