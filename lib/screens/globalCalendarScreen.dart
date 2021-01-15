import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/model/activitat.dart';

import 'activityScreen.dart';
import 'structureApp.dart';

const List<String> dies_semana = [
  'DILLUNS',
  'DIMARTS',
  'DIMECRES',
  'DIJOUS',
  'DIVENDRES',
  'DISSABTE'
];

Map<String, Color> colorsActivitat = {
  'Spinning': Colors.purple[100],
  'Calistenia': Colors.indigo,
  'Kickboxing': Colors.blueAccent,
  'Ioga': Colors.amber,
  'Crossfit': Colors.green[300]
};

final actualDate =
    DateTime(2020, 12, 14); //dataAvui (dilluns de la setmana actual)

DateTime weekStart =
    actualDate; //dilluns de la setmana que es mostra al calendari

var numDiaSem = List<DateTime>.generate(
    7,
    (i) => DateTime(weekStart.year, weekStart.month, weekStart.day)
        .add(Duration(days: i)));

/*List<int> numDiaSemana = [
  for (int i = 0; i < 6; i++) (weekStart.day + i)
]; //Llistat amb els dies [14, 15, 16..., 19]*/

var weekEnd = weekStart.add(Duration(days: 6));

class GlobalCalendarScreen extends StatefulWidget {
  /*const GlobalCalendarScreen({
    Key key,
    this.docs,
  }) : super(key: key);*/

  final List<String> filtre = [];
  final List<QueryDocumentSnapshot> docs;

  GlobalCalendarScreen({this.docs, List<String> listaFiltro}) {
    if (listaFiltro == null || listaFiltro.length == 0)
      filtre
          .addAll(['Spinning', 'Calistenia', 'Kickboxing', 'Ioga', 'Crossfit']);
    else {
      for (int i = 0; i < listaFiltro.length; i++) {
        filtre.add(listaFiltro[i]);
      }
    }
  }

  @override
  _GlobalCalendarScreenState createState() => _GlobalCalendarScreenState();
}

class _GlobalCalendarScreenState extends State<GlobalCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    //data final depen de data inici de manera automatica (ja no l'hem de crear)
    final act = FirebaseFirestore.instance.collection('Activitats').where(
        'inici',
        isGreaterThanOrEqualTo:
            actualDate); //data inici igual o superior a inici setmana

    return StreamBuilder(
        stream: act.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final llistaActivitats = snapshot.data.docs;

          bool actInscrita(var activ) { //////////////////////////////////ACABAR
            if(activ['num_assis']==0) return false;
            for(int j=0; j<6;j++){
              print('$j');
              return true;
            }
          }

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
                                nom: dies_semana[i] + '${numDiaSem[i].day}',
                                //nom: dies_semana[i] + '${numDiaSemana[i]}',
                                acth: [
                                  for (var a in llistaActivitats)
                                    //Hauria d'estar dins del dia
                                    //fer métode -- passe activitat i data
                                    //quan cliques <> que es generin els dies
                                    if (a['inici']
                                            .toDate()
                                            .isAfter(weekStart) &&
                                        a['inici'].toDate().isBefore(weekEnd) &&
                                        a['inici'].toDate().day ==
                                            numDiaSem[i].day &&
                                        widget.filtre.contains(a['tipus']))
                                      Activitat(
                                        a['tipus'],
                                        a['inici'].toDate(),
                                        a['final'].toDate(),
                                        a['lloc'],
                                        a['entrenador'],
                                        a['max_assis'],
                                        a['num_assis'],
                                        a.id,
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
  Future<Widget> actualitzaCalendar() async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        maintainState: true,
        builder: (context) => StructureApp(),
      ),
    );
  }

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
                setState(() {
                  weekStart = weekStart.add(Duration(days: -7));
                  weekEnd = weekStart.add(Duration(days: 6));
                  numDiaSem = List<DateTime>.generate(
                      7,
                      (i) => DateTime(
                              weekStart.year, weekStart.month, weekStart.day)
                          .add(Duration(days: i)));
                  actualitzaCalendar();
                });
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
                  'Setmana ${numDiaSem[0].day} / ${numDiaSem[0].month} / ${numDiaSem[0].year}',
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
                setState(() {
                  weekStart = weekStart.add(Duration(days: 7));
                  weekEnd = weekStart.add(Duration(days: 6));
                  numDiaSem = List<DateTime>.generate(
                      7,
                      (i) => DateTime(
                              weekStart.year, weekStart.month, weekStart.day)
                          .add(Duration(days: i)));
                  actualitzaCalendar();
                });
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
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black87,
                      pageBuilder: (BuildContext context, _, __) {
                        return ActivityScreen(
                            acth[index],
                            false); //mandamos la actividad 'seleccionada'
                      },
                    )).then((value) => null);
              },
              color: colorsActivitat[acth[index].nom],
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
} 

bool actInscrita() {
      //S'HA DE COMPROBAR SI L'USUARI ESTÀ REGISTRAT A L'ACTIV O NO
      bool inscrit = false;
      final act = FirebaseFirestore.instance
          .collection('Activitats')
          .doc('${acth[index].id}')
          .collection('assistents');
      return StreamBuilder(
          stream: act.snapshots(),
          // ignore: missing_return
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final assistents = snapshot.data.docs;
            
            for (int j = 0; j < assistents.length; j++) {
              //print('$j');
              if (FirebaseAuth.instance.currentUser.uid ==
                  assistents[j]['idUsuari']) {
                inscrit = true;
                //CREEM UNA LLISTA AMB LA INFO DE LES ACTIVITATS INSCRITES
              }
            }
          });
      return inscrit;
    }

*/
