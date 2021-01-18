import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/model/activitat.dart';
import 'package:proyecto/screens/personalCalendarScreen.dart';
import 'package:proyecto/screens/structureApp.dart';

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            width: 50,
                            child: FlatButton(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Container(
                                    width: 65,
                                    child: Image.asset(
                                      '${widget.activitat.nom}.png',
                                      fit: BoxFit.contain,
                                      color:
                                          colorsActivitat[widget.activitat.nom],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          height: 8,
                                        ),
                                        Text(
                                          ' Duració: ${widget.activitat.dataFinal.hour - widget.activitat.dataInici.hour}h',
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
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.activitat.dataInici.hour}:00 - ${widget.activitat.dataFinal.hour}:00',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Entrenador: ${widget.activitat.entrenador}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Places disponibles: ${widget.activitat.max_assis - widget.activitat.num_assis}/${widget.activitat.max_assis}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    '${widget.activitat.sala}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: RaisedButton(
                      color: widget.inscrit ? Colors.white : colorGym,
                      child: Text(
                        widget.inscrit ? 'CANCEL·LAR INSCRIPCIÓ' : 'INSCRIURE',
                        style: TextStyle(
                          color: widget.inscrit ? colorGym : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        //SI ESTAS INTENTANT CANCEL.LAR:
                        if (widget.inscrit) {
                          //DESAPUNTAR-TE:
                          final db = FirebaseFirestore.instance;
                          final userId = FirebaseAuth.instance.currentUser.uid;
                          final activitatId = widget.activitat.id;

                          final userRef = db.doc('Usuaris/$userId');
                          final activitatRef =
                              db.doc('Activitats/$activitatId');

                          var inscripEnUsuari = userRef
                              .collection('inscripcions')
                              .doc(activitatId);
                          var inscripEnActivitat =
                              activitatRef.collection('assistents').doc(userId);

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
                          final db = FirebaseFirestore.instance;
                          final userId = FirebaseAuth.instance.currentUser.uid;
                          final activitatId = widget.activitat.id;

                          final userRef = db.doc('Usuaris/$userId');
                          final activitatRef =
                              db.doc('Activitats/$activitatId');

                          var inscripEnUsuari = userRef
                              .collection('inscripcions')
                              .doc(activitatId);
                          var inscripEnActivitat =
                              activitatRef.collection('assistents').doc(userId);

                          return db.runTransaction(
                            (transaction) async {
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
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
