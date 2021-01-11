import 'package:flutter/material.dart';
import 'package:proyecto/model/activitat.dart';

class ActivityScreen extends StatelessWidget {
  final activitat;
  final bool inscrit;
  ActivityScreen(this.activitat, this.inscrit);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'activityScreen',
      home: Activity(activitat, inscrit),
    );
  }
}

class Activity extends StatefulWidget {
  final Activitat activitat;
  final bool inscrit;
  Activity(this.activitat, this.inscrit);
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
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
                              if (widget.inscrit) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirmació'),
                                    content:
                                        Text('Segur que et vols desapuntar?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          //ha de fer la transacció esborrant i després pop
                                        },
                                        child: Text('Confirmar'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar'),
                                      )
                                    ],
                                  ),
                                );
                              }
                              //apunta a l'activitat (+RunTransaction!!)
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
