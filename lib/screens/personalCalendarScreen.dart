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
    final activitats = FirebaseFirestore.instance.collection(
        'Activitats'); //recollim dades de firebase amb les activitats

    final inscripcionsUser = FirebaseFirestore.instance
        .collection('Usuaris')
        .doc(
            'c5Dz89sXkUZ7s77yI8pdPQ6s0Nz1') //preguntar com posar aqui el usuari que esta amb login?????????????
        .collection(
            'inscripcions'); //recollim les dades de les inscripcions , en aquest cas nomes d`un usuari

    return StreamBuilder(
        stream: inscripcionsUser.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final inscripcionsDocs =
              snapshot.data.docs; //LLISTA DE CODIS ACT INSCRITES USUARI

          return StreamBuilder(
              stream: activitats.orderBy('inici').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final actsDocs =
                    snapshot.data.docs; //LLISTA D'ACT EXISTENTS AL GIMNÀS
                final llistaActCompletes = [];

                for (int i = 0; i < inscripcionsDocs.length; i++) {
                  //// filtre per encreuar les dades de les 2 coleccions
                  for (int j = 0; j < actsDocs.length; j++) {
                    if (inscripcionsDocs[i].id == actsDocs[j].id) {
                      llistaActCompletes.add(actsDocs[
                          j]); //CREEM UNA LLISTA AMB LA INFO DE LES ACTIVITATS INSCRITES
                    }
                  }
                }

                return ListView.builder(
                  itemCount: llistaActCompletes.length,
                  itemBuilder: (context, index) {
                    final item = llistaActCompletes[index];

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 90,
                        child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                    Text(
                                    item['inici']
                                        .toDate()
                                        .day
                                        .toString(), //no sé comm imprimir la data com volem: DL 10:00 - 11:00h
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text('.'),
                                  Text(
                                    item['inici']
                                        .toDate()
                                        .month
                                        .toString(), //no sé comm imprimir la data com volem: DL 10:00 - 11:00h
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(' de '),
Text(
                                    item['inici']
                                        .toDate()
                                        .hour
                                        .toString(), //no sé comm imprimir la data com volem: DL 10:00 - 11:00h
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
Text(' a '),
Text(
                                    item['final']
                                        .toDate()
                                        .hour
                                        .toString(), //no sé comm imprimir la data com volem: DL 10:00 - 11:00h
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                ]),
                                Text(item['tipus']),
                                Text(
                                  item['lloc'],
                                  style: TextStyle(color: Colors.grey[500]),
                                )
                              ],
                            ),
                            trailing: Icon(Icons.remove),
                            leading: Container(
                                child: Image.asset(
                              '${item['tipus']}.png',
                              fit: BoxFit.cover,
                            ))),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: new Offset(0.0, 1.0),
                              blurRadius: 50.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                );
              });
        });
  }
}
