import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalCalendarScreen extends StatelessWidget {
  const GlobalCalendarScreen({
    Key key,
    @required this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    final act = FirebaseFirestore.instance.collection('Activitats');

    return StreamBuilder(
      stream: act.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data.docs;
    return ListView.builder(
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
  });
}}