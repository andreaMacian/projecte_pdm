import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

const Map<int, String> messos = {
  1: 'Gener',
  2: 'Febrer',
  3: 'Març',
  4: 'Abril',
  5: 'Maig',
  6: 'Juny',
  7: 'Juliol',
  8: 'Agost',
  9: 'Septembre',
  10: 'Ocutubre',
  11: 'Novembre',
  12: 'Desembre'
};

final Map<String, Color> colorsActivitat = {
  'Spinning': Color.fromRGBO(213, 134, 207, 1),
  'Calistenia': Color.fromRGBO(139, 109, 176, 1),
  'Kickboxing': Color.fromRGBO(71, 200, 255, 1),
  'Ioga': Color.fromRGBO(255, 206, 71, 1),
  'Crossfit': Color.fromRGBO(93, 192, 103, 1),
};
final Map<String, Color> colorsActivitatInscrites = {
  'Spinning': Color.fromRGBO(239, 210, 237, 1),
  'Calistenia': Color.fromRGBO(192, 175, 212, 1),
  'Kickboxing': Color.fromRGBO(194, 237, 255, 1),
  'Ioga': Color.fromRGBO(255, 228, 153, 1),
  'Crossfit': Color.fromRGBO(167, 221, 172, 1),
};

class GlobalCalendarScreen extends StatefulWidget {
  final List<String> filtre = [];
  final List<QueryDocumentSnapshot> docs;

  GlobalCalendarScreen({
    this.docs,
    List<String> listaFiltro,
  }) {
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
  DateTime weekStart = DateTime(2021, 01, 18);
  List<DateTime> numDiaSem;

  @override
  void initState() {
    numDiaSem = List<DateTime>.generate(
      7,
      (i) => DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day,
      ).add(
        Duration(days: i),
      ),
    );

    super.initState();
  }

  void _moveWeek(int days) {
    setState(() {
      weekStart = weekStart.add(Duration(days: days));
      numDiaSem = List<DateTime>.generate(
          7,
          (i) => DateTime(weekStart.year, weekStart.month, weekStart.day)
              .add(Duration(days: i)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final llistaActivitats = Provider.of<List<Activitat>>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: CanviSetmanaCalendari(
              day: numDiaSem[0],
              onNext: () => _moveWeek(7),
              onPrev: () => _moveWeek(-7),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //Llista on son les hores
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  //scroll amb els dies i activitats
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < dies_semana.length; i++)
                        DiaCalendari2(
                          nom: dies_semana[i] + ' ${numDiaSem[i].day}',
                          acth: [
                            for (var activitat in llistaActivitats)
                              if (activitat.dataInici.isAfter(numDiaSem[0]) &&
                                  activitat.dataInici.isBefore(numDiaSem[6]) &&
                                  activitat.dataInici.day == numDiaSem[i].day &&
                                  widget.filtre.contains(activitat.nom))
                                activitat
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
  }
}

class CanviSetmanaCalendari extends StatefulWidget {
  final DateTime day;
  final Function onNext;
  final Function onPrev;
  CanviSetmanaCalendari({
    @required this.day,
    @required this.onNext,
    @required this.onPrev,
  });

  @override
  _CanviSetmanaCalendariState createState() => _CanviSetmanaCalendariState();
}

class _CanviSetmanaCalendariState extends State<CanviSetmanaCalendari> {
  @override
  Widget build(BuildContext context) {
    final actualDate = DateTime(2021, 01, 18);
    final day = widget.day;

    //widget superior per canviar setmana:
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
            actualDate == day
                ? SizedBox(width: 88)
                : FlatButton(
                    child: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: widget.onPrev,
                  ),
            Column(
              children: [
                Text(
                  '${messos[day.month]} ${day.year}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Setmana ${day.day} / ${day.month} / ${day.year}',
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
              onPressed: widget.onNext,
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
                        acth[index].inscrita,
                      );
                    },
                  ),
                ).then((value) => null);
              },
              color: acth[index].inscrita
                  ? colorsActivitatInscrites[acth[index].nom]
                  : colorsActivitat[acth[index].nom],
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
