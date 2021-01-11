import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
//podriamos coger los nombres de los datos de fireStore
  List<String> tipusActivitats = [
    'Spinning',
    'Calistenia',
    'Kickboxing',
    'Ioga',
    'Crossfit'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10, //medio transparente
      body: Container(
        alignment: Alignment.topRight,
        child: Container(
          alignment: Alignment.topLeft,
          width: 250,
          height: 650,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FlatButton(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                  ),
                  onPressed: () {
                    //Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Tipus Activitats',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[850]),
                ),
                SizedBox(
                  height: 20,
                ),
                for (int i = 0; i < tipusActivitats.length; i++)
                  TipusActivitat(tipusActivitats[i]),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.green[100],
                      child: Text(
                        'FILTRA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TipusActivitat extends StatelessWidget {
  /*const TipusActivitat({
    Key key,
  }) : super(key: key);*/
  final String nomActivitat;
  bool seleccionada;
  TipusActivitat(this.nomActivitat);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: Colors.grey[100],
        height: 20,
        //decoration: BoxDecoration(border: BoxBorder()),
        child: Row(
          children: [
            /*Checkbox(
              value: seleccionada,
              onChanged: (bool newValue) {
                seleccionada=newValue;
              }),*/
            Text(
              '$nomActivitat',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
