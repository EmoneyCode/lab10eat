import 'package:flutter/material.dart';
import 'package:flutter_demo_29_september/cluans.dart';
import 'package:provider/provider.dart';

class ListViewPlayground extends StatelessWidget {
  int index;
  ListViewPlayground(this.index);
  @override
  Widget build(BuildContext context) {
    final cluansDecider = context.watch<CluanModel>();
    final cluans = (index == 1 ) 
        ? cluansDecider.cluanContent.where((c)=>c.user_id == cluansDecider.supabaseClient.auth.currentUser?.id).toList()
        : cluansDecider.cluanContent;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: Colors.white, thickness: 1.0),
            itemCount: cluans.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                cluans[index].clue!,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                cluans[index].answer!,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              trailing: Text(
                cluans[index].created_at.toString()!.split(' ')[0],
              ),
              onLongPress: () => cluansDecider.remove(cluans.elementAt(index)),
            ),
          ),
        ),
      ),
    );
  }
}
