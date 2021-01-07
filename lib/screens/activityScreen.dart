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
                  color: Colors.transparent,
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
                          Navigator.of(context).pop(); //de moment torna a la structureApp
                          //screen = 2; //si vens del personal calendar hauria de ser screen = 1
                        }
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height:30,
                        child: RaisedButton(
                          onPressed: () {},
                            color: Colors.blue[100],
                            child: Center(
                              child: Text('CANCEL·LAR INSCRIPCIÓ'),
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
