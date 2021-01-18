import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/model/activitat.dart';
import 'package:proyecto/screens/structureApp.dart';

import 'activityScreen.dart';

final Map<String, Color> colorsActivitat = {
  'Spinning': Color.fromRGBO(231, 187, 227, 1),
  'Calistenia': Color.fromRGBO(125, 91, 166, 1),
  'Kickboxing': Color.fromRGBO(0, 166, 237, 1),
  'Ioga': Color.fromRGBO(255, 202, 58, 1),
  'Crossfit': Color.fromRGBO(125, 205, 133, 1),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '/',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.activitat.dataInici.month.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' de ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.activitat.dataInici.hour.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' a ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.activitat.dataFinal.hour.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              SizedBox(
                height: 3,
              ),
              Text(
                widget.activitat.nom,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
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
              screen =
                  2; //per que torni a la pantalla de personal screen per si volem seguir cancelant o consultant
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black87,
                    pageBuilder: (BuildContext context, _, __) {
                      return ActivityScreen(widget.activitat, true);
                    },
                  ));
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
