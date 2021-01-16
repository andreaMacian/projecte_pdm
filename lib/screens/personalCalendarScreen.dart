//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/model/activitat.dart';
import 'package:proyecto/screens/structureApp.dart';

import 'activityScreen.dart';

Map<String, Color> colorsActivitat = {
  'Spinning': Colors.purple[100],
  'Calistenia': Colors.indigo,
  'Kickboxing': Colors.blueAccent,
  'Ioga': Colors.amber,
  'Crossfit': Colors.green[300]
};

class PersonalCalendarScreen extends StatelessWidget {
  const PersonalCalendarScreen({
    Key key,
    this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    final llistaActivitats = Provider.of<List<Activitat>>(context);

    // CREEM UNA LLISTA AMB LA INFO DE LES ACTIVITATS INSCRITES
    final llistaActInscrites = [];
    for (int j = 0; j < llistaActivitats.length; j++) {
      final activitat = llistaActivitats[j];
      if (activitat.inscrita) {
        llistaActInscrites.add(activitat);
      }
    }

    return ListView.builder(
      itemCount: llistaActInscrites.length,
      itemBuilder: (context, index) {
        final item = llistaActInscrites[index];
        return ActivitatInscrita(activitat: item);
      },
    );
  }
}

class ActivitatInscrita extends StatefulWidget {
  const ActivitatInscrita({
    Key key,
    @required this.activitat,
  }) : super(key: key);

  final Activitat activitat;

  @override
  _ActivitatInscritaState createState() => _ActivitatInscritaState();
}

class _ActivitatInscritaState extends State<ActivitatInscrita> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 90,
        child: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  widget.activitat.dataInici.day.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('/'),
                Text(
                  widget.activitat.dataInici.month.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(' de '),
                Text(
                  widget.activitat.dataInici.hour.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(' a '),
                Text(
                  widget.activitat.dataFinal.hour.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
              SizedBox(
                height: 3,
              ),
              Text(widget.activitat.nom),
              SizedBox(
                height: 3,
              ),
              Text(
                widget.activitat.sala,
                style: TextStyle(color: Colors.grey[500]),
              )
            ],
          ),
          trailing: FlatButton(
            child: Icon(Icons.remove_circle_outline),
            onPressed: () {
              screen = 2;//per que torni a la pantalla de personal screen per si volem seguir cancelant o consultant
              //OPCIÓN 2: (AL VOLVER A LA PANTALLA ANTIGUA SE BLOQUEA LA APP)
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black87,
                    pageBuilder: (BuildContext context, _, __) {
                      return ActivityScreen(widget.activitat, true);
                    },
                  ));
              //OPCIÓN 1 : (SE PONE LA PANTALLA NEGRA)
              /*Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ActivityScreen(
                        Activitat(
                          widget.item['tipus'],
                          widget.item['inici'].toDate(),
                          widget.item['final'].toDate(),
                          widget.item['lloc'],
                          widget.item['entrenador'],
                          widget.item['max_assis'],
                          widget.item['num_assis'],
                        ),
                        true), //mandamos la actividad 'seleccionada'
                  ),
                )*/
              //TENDREMOS QUE PONER EL THEN
            },
          ),
          leading: Container(
            width: 80,
            child: Image.asset(
              '${widget.activitat.nom}.png',
              fit: BoxFit.contain,
              color: colorsActivitat[widget.activitat.nom],
            ),
          ),
        ),
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
  }
}
