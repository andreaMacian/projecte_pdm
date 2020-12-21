import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalCalendarScreen extends StatelessWidget {
  const GlobalCalendarScreen({
    Key key,
    this.docs,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //mes+setmana+botons canvi de setmana
                height: 80,
                color: Colors.red,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //CONTAINER CON LAS HORAS
                      width: 50,
                      color: Colors.green,
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (int i = 0; i < 6; i++) DiaCalendari(docs: docs)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class DiaCalendari extends StatelessWidget {
  const DiaCalendari({
    Key key,
    @required this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      color: Colors.grey,
      child: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final item = docs[index];
          return ListTile(
            title: Text(
              item['tipus'],
            ),
          );
        },
      ),
    );
  }
}
