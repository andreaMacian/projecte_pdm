import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/model/activitat.dart';

import 'filterScreen.dart';
import 'globalCalendarScreen.dart';
import 'newsScreen.dart';
import 'personalCalendarScreen.dart';

List<String> actsFiltre = [];
final Color colorGym = Color.fromARGB(255, 106, 204, 173);

class StructureApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final inscripcionsUser = FirebaseFirestore.instance
        .collection('Usuaris')
        .doc('${FirebaseAuth.instance.currentUser.uid}')
        .collection(
            'inscripcions'); //recollim les dades de les inscripcions del user logIn

    return StreamBuilder(
      stream: inscripcionsUser.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final inscripcionsDocs =
            snapshot.data.docs; //llista codis activ inscrites user

        final Set<String> inscripcions = Set<String>();
        for (var inscr in inscripcionsDocs) {
          inscripcions.add(inscr.id);
        }

        return StreamBuilder(
          stream: llistaActivitats(),
          builder: (context, AsyncSnapshot<List<Activitat>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final llistaActivitats = snapshot.data;

            for (int i = 0; i < llistaActivitats.length; i++) {
              final activitat = llistaActivitats[i];
              if (inscripcions.contains(activitat.id)) {
                activitat.inscrita = true;
              }
            }

            return Provider.value(
              value: llistaActivitats,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Gimnàs UFit: User App',
                home: MyHomePage(),
              ),
            );
          },
        );
      },
    );
  }
}

int screen = 1;

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*
    0 -> newsScreen
    1 -> CalendarGlobal
    2 -> personalCalendar
    */

  String title = "Calendari d'Activitats";
  List<String> listaFiltro = [
    'Spinning',
    'Calistenia',
    'Kickboxing',
    'Ioga',
    'Crossfit',
  ];

  @override
  Widget build(BuildContext context) {
    var mainwidget;
    if (screen == 0) {
      //go to news screen
      mainwidget = NewsScreen();
      title = "Notícies";
    } else if (screen == 1) {
      //calendar global
      mainwidget = GlobalCalendarScreen(
        listaFiltro: listaFiltro,
      );
      title = "Calendari d'Activitats";
    } else {
      //go to Personal calendar Screen
      mainwidget = PersonalCalendarScreen();
      title = "Calendari Personal";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        backgroundColor: colorGym,
        actions: [
          (screen == 1)
              ? IconButton(
                  icon: Icon(Icons.filter_alt_outlined),
                  onPressed: () {
                    actsFiltre = [];
                    listaFiltro = [
                      'Spinning',
                      'Calistenia',
                      'Kickboxing',
                      'Ioga',
                      'Crossfit',
                    ]; //reiniciem el filtre cada cop que entrem
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => FilterScreen(
                        listaFiltro: listaFiltro,
                      ),
                    ))
                        .then((actsFiltre) {
                      setState(() {
                        listaFiltro = actsFiltre;
                      });
                    });
                  },
                )
              : (screen == 2)
                  ? IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        screen = 1;
                        FirebaseAuth.instance.signOut();
                      },
                    )
                  : SizedBox(), //cap icona
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: mainwidget,
            ),
            BottomAppBar(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      FlatButton(
                        child: Icon(Icons.list,
                            color: (screen == 0) ? Colors.grey : Colors.black),
                        onPressed: () {
                          setState(() {
                            screen = 0;
                          });
                        },
                      ),
                      Spacer(),
                      FlatButton(
                        child: Icon(Icons.calendar_today,
                            color: (screen == 1) ? Colors.grey : Colors.black),
                        onPressed: () {
                          setState(() {
                            screen = 1;
                          });
                        },
                      ),
                      Spacer(),
                      FlatButton(
                        child: Icon(Icons.perm_contact_calendar,
                            color: (screen == 2) ? Colors.grey : Colors.black),
                        onPressed: () {
                          setState(() {
                            screen = 2;
                          });
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
