import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/model/activitat.dart';

import 'activityScreen.dart';

const List<String> dies_semana = [
  'DILLUNS',
  'DIMARTS',
  'DIMECRES',
  'DIJOUS',
  'DIVENDRES',
  'DISSABTE'
];
/*final weekstart = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);// he de fer que aquesta data pugi o baixi a partir de la nostra setmana actual*/

final weekstart =
    DateTime(2020, 12, 14); //weekstart provisional per visualitzar containers

class GlobalCalendarScreen extends StatelessWidget {
  const GlobalCalendarScreen({
    Key key,
    this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    final weekend = weekstart.add(Duration(
        days:
            6)); //data final depen de data inici de manera automatica (ja no l'hem de crear)
    final act = FirebaseFirestore.instance.collection('Activitats').where(
        'inici',
        isGreaterThanOrEqualTo:
            weekstart); //data inici igual o superior a inici setmana

    List<int> diessemana = []; //Llistat amb els dies [14, 15, 16..., 19]
    for (int i = 0; i < 6; i++) {
      diessemana.add(weekstart.day + i);
    }

    return StreamBuilder(
        stream: act.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final llistaActivitats = snapshot.data.docs;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: CanviSetmanaCalendari(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        //CONTAINER CON LAS HORAS
                        width: 60,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int i = 9; i < 22; i++)
                                      Text(
                                        '$i:00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        //Lista horizontal con los días
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 0; i < dies_semana.length; i++)
                              DiaCalendari2(
                                nom: dies_semana[i],
                                acth: [
                                  for (var a in llistaActivitats)
                                    //Hauria d'estar dins del dia
                                    //fer métode -- passe activitat i data
                                    //quan cliques <> que es generin els dies
                                    if (a['inici']
                                            .toDate()
                                            .isAfter(weekstart) &&
                                        a['inici'].toDate().isBefore(weekend) &&
                                        a['inici'].toDate().day ==
                                            diessemana[i])
                                      Activitat(
                                        a['tipus'],
                                        a['inici'].toDate(),
                                        a['final'].toDate(),
                                        a['lloc'],
                                        a['entrenador'],
                                        a['max_assis'],
                                        a['num_assis'],
                                      )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class CanviSetmanaCalendari extends StatefulWidget {
  @override
  _CanviSetmanaCalendariState createState() => _CanviSetmanaCalendariState();
}

class _CanviSetmanaCalendariState extends State<CanviSetmanaCalendari> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            offset: new Offset(0.0, 1.0),
            blurRadius: 50.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                weekstart
                    .add(Duration(days: 7)); //posem 7 dies al inici de setmana
              },
            ),
            Column(
              children: [
                Text(
                  '${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Setmana 3',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            FlatButton(
              child: Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {
                weekstart.subtract(
                    Duration(days: 7)); //treiem 7 dies al inici de setmana
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DiaCalendari2 extends StatefulWidget {
  final String nom;
  final List<Activitat> acth;
  DiaCalendari2({@required this.nom, this.acth = const []});

  @override
  _DiaCalendari2State createState() => _DiaCalendari2State();
}

class _DiaCalendari2State extends State<DiaCalendari2> {
  Widget activity(List<Activitat> acth, int hora) {
    final int index = acth.indexWhere((a) => a.dataInici.hour == hora);
    return Container(
      height: 34,
      child: index != -1
          ? RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ActivityScreen(acth[index],
                        false), //mandamos la actividad 'seleccionada'
                  ),
                );
              },
              color: Colors.blue[100],
              child: Center(
                child: Text('${acth[index].nom}'),
              ),
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: new Offset(0.0, 1.0),
              blurRadius: 50.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              child: Text(
                this.widget.nom,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              height: 40,
              alignment: Alignment.center,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int hora = 9; hora < 22; hora++)
                    activity(widget.acth, hora),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class DiaCalendari extends StatelessWidget {
  DiaCalendari({
    Key key,
    @required this.docs,
    @required this.dia,
  }) : super(key: key);
 
  final List<QueryDocumentSnapshot> docs;
  final int dia;
  final List semana = [
    'DILLUNS',
    'DIMARTS',
    'DIMECRES',
    'DIJOUS',
    'DIVENDRES',
    'DISSABTE'
  ];
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: new Offset(0.0, 1.0),
              blurRadius: 50.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              child: Text(
                '${semana[this.dia - 1]}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              height: 40,
              alignment: Alignment.center,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 9; i < 22; i++)
                    Container(
                      height: 35,
                      child: (i == 9 &&
                              docs[0]['final']
                                      .toDate()
                                      .toString()
                                      .split(" ")[1] ==
                                  "09:00:00.000")
                          ? RaisedButton(
                              onPressed: () {},
                              color: Colors.blue[100],
                              child: Center(
                                  child: Text(docs[0]['final']
                                      .toDate()
                                      .toString()
                                      .split(" ")[0])),
                            )
                          : SizedBox(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
