//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';







class PersonalCalendarScreen extends StatelessWidget {
  const PersonalCalendarScreen({
    Key key,
    this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {

  final act = FirebaseFirestore.instance.collection('Activitats'); //recollim dades de firebase amb les activitats
  final ins = FirebaseFirestore.instance.collection('Usuaris').doc('c5Dz89sXkUZ7s77yI8pdPQ6s0Nz1').collection('inscripcions');
  
  



    return StreamBuilder(
      stream: act.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
  
        
  
        final actDocs = snapshot.data.docs;
          return ListView.builder(
         
          itemCount: actDocs.length,
          itemBuilder: (context, index) {
            final item = actDocs[index];
               for (int i =0; i< actDocs.length ;i++){
                 if (actDocs.id == ins.id){ }
               }
            return ListTile(
              title:Text(item.id)
            );
          },
        ); 
      },
    );

/* return StreamBuilder(
      stream: ins.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final insDocs = snapshot.data.docs;
          return ListView.builder(
          itemCount: insDocs.length,
          itemBuilder: (context, index) {
            final itemins = insDocs[index];
            return ListTile(
              title:Text(itemins.id)
            );
          },
        ); 
      },
    ); */




  }
}
