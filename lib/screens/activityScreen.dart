import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GimnàsApp test xavi',
      home: Activity(),
    );
  }
}

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlatButton(
            child: 
              Container (
                decoration: BoxDecoration(
                  color: Colors.transparent, //No surt transparent (Que es vegi la pantalla anterior) He probat també de fer-ho amb el opacity
              ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // torna a la PersonalCalendarScreen pero apareix una pantalla negra entre mig
                  //screen = 2; //si vens del personal calendar hauria de ser screen = 1
                }
              ),
          Center(
            child: Container( 
              height: 400,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      FlatButton(
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.of(context).pop(); //de moment surt una pantalla negra 
                          //screen = 2; //si vens del personal calendar hauria de ser screen = 1? o al fer pop ja hauria de funcionar?
                        }
                      ),
                    ],
                  ),
                  Column(
                    children: [/*Per que apareguin els icones, noms i informació de l'activitat que hem clicat
                     ho puc fer amb un this.?
                     O també m'haig de baixar totes les dades del firebase i seleccinor l'activitat clicada?*/
                      Container(
                        height:30,
                        child: RaisedButton( //Que aparegui el botó de inscripció en el cas que vinguis del globalCalendar
                          onPressed: () {}, //Que actualitzi les dades (+RunTransaction!!)
                            color: Colors.blue[100],
                            child: Center(
                              child: Text('CANCEL·LAR INSCRIPCIÓ'), //Pantalla de confirmar desinscripció
                            ),
                        ),
                      ),
                  ],), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*
Em falta fer Navigator.of en els RaisedButtons de les activitats del global calendar 
(No em deixa, crec que haig de fer un widjed d'aquests raisedButtons)
*/