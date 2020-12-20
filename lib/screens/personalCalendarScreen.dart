import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final user = FirebaseFirestore.instance.collection('Usuaris');


class PersonalCalendarScreen extends StatelessWidget {
  const PersonalCalendarScreen({
    Key key,
    @required this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //Aquí anirà el widget del calendari personal
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final item = docs[index];
        return ListTile(
          title: Text(
            item['tipus'],
          ),
        );
      },
    );
  }
}
