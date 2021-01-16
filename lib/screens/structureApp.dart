import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'filterScreen.dart';
import 'globalCalendarScreen.dart';
import 'newsScreen.dart';
import 'personalCalendarScreen.dart';

 List<String> actsFiltre = [];

class StructureApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GimnàsApp test xavi',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int screen = 1;
  String title = "Calendari d'Activitats";
  /*
    0 -> newsScreen
    1 -> CalendarGlobal
    2 -> personalCalendar
    */

  @override
  Widget build(BuildContext context) {
    var mainwidget;
    if (screen == 0) {
      //go to news screen
      mainwidget = NewsScreen();
      title = "Notícies";
    } else if (screen == 1) {
      //calendar global
      //Aquí anirà el widget del calendari global
      mainwidget = GlobalCalendarScreen(listaFiltro: actsFiltre);
      title = "Calendari d'Activitats";
    } else {
      //go to Personal calendar Screen
      mainwidget = PersonalCalendarScreen();
      title = "Calendari Personal";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        actions: [
          (screen == 1)
              ? IconButton(
                  icon: Icon(Icons.filter_alt_outlined),
                  onPressed: () {
                    actsFiltre = [];//reiniciem el filtre
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => FilterScreen(),
                    ))
                        .then((actsFiltre) {
                      setState(() {
                        GlobalCalendarScreen(listaFiltro: actsFiltre); 
                      });
                    });
                  },
                )
              : (screen == 2)
                  ? IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                    )
                  : SizedBox(), //que no haya ningún icono
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
