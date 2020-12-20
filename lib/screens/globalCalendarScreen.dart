import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'newsScreen.dart';
import 'personalCalendarScreen.dart';

class GlobalCalendarScreen extends StatelessWidget {
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
  /*
    0 -> newsScreen
    1 -> CalendarGlobal
    2 -> personalCalendar
    */
  @override
  Widget build(BuildContext context) {
    final act = FirebaseFirestore.instance.collection('Activitats');

    return StreamBuilder(
      stream: act.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data.docs;

        var mainwidget;
        if (screen == 0) {
          //go to news screen
          mainwidget = NewsScreen();
        } else if (screen == 1) {
          //calendar global
          //Aquí anirà el widget del calendari global
          mainwidget = ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index];
              return ListTile(
                title: Text(
                  item['tipus'],
                ),
              );
            },
          );
        } else {
          //go to Personal calendar Screen
          mainwidget = PersonalCalendarScreen(docs: docs);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Gimnas App"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
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
                            child: Icon(Icons.list),
                            onPressed: () {
                              setState(() {
                                screen = 0;
                              });
                            },
                          ),
                          Spacer(),
                          FlatButton(
                            child: Icon(Icons.calendar_today),
                            onPressed: () {
                              setState(() {
                                screen = 1;
                              });
                            },
                          ),
                          Spacer(),
                          FlatButton(
                            child: Icon(Icons.perm_contact_calendar),
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
      },
    );
  }
}
