import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/model/activitat.dart';
import 'package:proyecto/screens/personalCalendarScreen.dart';

class ActivityScreen extends StatefulWidget {
  final Activitat activitat;
  final bool inscrit;
  ActivityScreen(this.activitat, this.inscrit);
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10, //medio transparente
      body: Container(
        child: Center(
          child: Container(
            height: 400,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                      width: 50,
                      child: FlatButton(
                          child: Icon(
                            Icons.arrow_back_ios,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); //de moment surt una pantalla negra
                            //screen = 2; //si vens del personal calendar hauria de ser screen = 1? o al fer pop ja hauria de funcionar?
                          }),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 65,
                              child: Image.asset(
                                '${widget.activitat.nom}.png',
                                fit: BoxFit.contain,
                                color: colorsActivitat[widget.activitat.nom],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.activitat.nom}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Duració: ${widget.activitat.dataFinal.hour - widget.activitat.dataInici.hour}h',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          '${widget.activitat.dataInici.hour}:00 - ${widget.activitat.dataFinal.hour}:00',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Entrenador: ${widget.activitat.entrenador}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Places disponibles: ${widget.activitat.max_assis - widget.activitat.num_assis}/${widget.activitat.max_assis}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          '${widget.activitat.sala}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[400],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            color: widget.inscrit
                                ? Colors.green[100]
                                : Colors.green[300],
                            child: Text(
                              widget.inscrit
                                  ? 'CANCEL·LAR INSCRIPCIÓ'
                                  : 'INSCRIURE',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              //SI ESTAS INTENTANT CANCEL.LAR:
                              if (widget.inscrit) {
                                //DESAPUNTAR-TE:
                                final db = FirebaseFirestore.instance;
                                final userId =
                                    FirebaseAuth.instance.currentUser.uid;
                                final activitatId = widget.activitat.id;

                                final userRef = db.doc('Usuaris/$userId');
                                final activitatRef =
                                    db.doc('Activitats/$activitatId');

                                var inscripEnUsuari = userRef
                                    .collection('inscripcions')
                                    .doc(activitatId);
                                var inscripEnActivitat = activitatRef
                                    .collection('assistents')
                                    .doc(userId);

                                return db.runTransaction((transaction) async {
                                  FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    transaction.update(activitatRef, {
                                      'num_assis': FieldValue.increment(
                                          -1), //TREIEM un assistent
                                    });
                                    transaction.delete(
                                        inscripEnUsuari); //BORRAS activ del usuario
                                    transaction.delete(
                                        inscripEnActivitat); //BORRAS usuario de la acti
                                  }).catchError((e) {
                                    return false;
                                  });
                                  Navigator.of(context).pop();
                                });
                              }
                              //SI T'ESTAS INTENTANT APUNTAR:
                              else {
                                //ha de fer la transacció apuntant ACT DE INSCRIPCIONS USUARI
                                //I A USUARI DE L'ACTIVITAT i després pop
                                //OPCIO 1:
                                final db = FirebaseFirestore.instance;
                                final userId =
                                    FirebaseAuth.instance.currentUser.uid;
                                final activitatId = widget.activitat.id;

                                final userRef = db.doc('Usuaris/$userId');
                                final activitatRef =
                                    db.doc('Activitats/$activitatId');

                                var inscripEnUsuari = userRef
                                    .collection('inscripcions')
                                    .doc(activitatId);
                                var inscripEnActivitat = activitatRef
                                    .collection('assistents')
                                    .doc(userId);

                                /*
                                var assistents = debugAssertAllWidgetVarsUnset(reason)
                                    .collection('Activitats')
                                    .doc(widget.activitat.id);
                                */
                                return db.runTransaction((transaction) async {
                                  FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    transaction.update(activitatRef, {
                                      'num_assis': FieldValue.increment(
                                          1), //añadimos un asistente
                                    });
                                    transaction.set(inscripEnUsuari,
                                        {}); //añades activ vacía al usuario
                                    transaction.set(inscripEnActivitat,
                                        {}); //añades usuario vacío a la acti
                                  }).catchError((e) {
                                    return false;
                                  });
                                  Navigator.of(context).pop();
                                });
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
