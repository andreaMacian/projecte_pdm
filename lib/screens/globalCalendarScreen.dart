import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlobalCalendarScreen extends StatelessWidget {
  const GlobalCalendarScreen({
    Key key,
    this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: CanviSetmanaCalendari(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        //CONTAINER CON LAS HORAS
                        width: 60,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                          ],
                        ),
                      ),
                      Expanded(
                        //Lista horizontal con los días
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 1; i < 7; i++)
                              DiaCalendari(docs: docs, dia: i)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class CanviSetmanaCalendari extends StatefulWidget {
  @override
  _CanviSetmanaCalendariState createState() => _CanviSetmanaCalendariState();
}

class _CanviSetmanaCalendariState extends State<CanviSetmanaCalendari> {
  @override
  Widget build(BuildContext context) {
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
            FlatButton(
              child: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {},
            ),
            Column(
              children: [
                Text(
                  '${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Setmana 1',
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DiaCalendari extends StatelessWidget {
  DiaCalendari({
    Key key,
    @required this.docs,
    @required this.dia,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;
  final int dia;
  final List semana = [
    'DILLUNS',
    'DIMARTS',
    'DIMECRES',
    'DIJOUS',
    'DIVENDRES',
    'DISSABTE'
  ];

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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              child: Text(
                '${semana[this.dia - 1]}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              height: 40,
              alignment: Alignment.center,
            ),
            //EL QUE HI HAVIA ABANS
            /*Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final item = docs[index];
                  return ListTile(
                    title: Text(
                      item['tipus'],
                    ),
                  );
                },
              ),
            ),*/
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 9; i < 22; i++)
                    Container(
                      height: 35,
                      child: (i == 9 &&
                              docs[0]['final']
                                      .toDate()
                                      .toString()
                                      .split(" ")[1] ==
                                  "09:00:00.000")
                          ? RaisedButton(
                              onPressed: () {},
                              color: Colors.blue[100],
                              child: Center(
                                  child: Text(docs[0]['final']
                                      .toDate()
                                      .toString()
                                      .split(" ")[0])),
                            )
                          : SizedBox(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
