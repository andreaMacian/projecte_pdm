import 'package:flutter/material.dart';

class TypeActivities {
  String nomActivity;
  bool selected;
  TypeActivities(this.nomActivity, this.selected);
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
//podriamos coger los nombres de los datos de fireStore
  List<String> llistaAct = [
    'Spinning',
    'Calistenia',
    'Kickboxing',
    'Ioga',
    'Crossfit'
  ];
  List<TypeActivities> tipusActivitats = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < llistaAct.length; i++) {
      tipusActivitats.add(TypeActivities(llistaAct[i], false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10, //medio transparente
      body: Container(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
          ),
          width: 250,
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'Tipus Activitats',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[850]),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tipusActivitats.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Checkbox(
                          value: tipusActivitats[index].selected,
                          onChanged: (bool newValue) {
                            setState(() {
                              tipusActivitats[index].selected = newValue;
                            });
                          },
                        ),
                        title: Text('${tipusActivitats[index].nomActivity}'),
                      );
                    },
                  ),
                ),
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
                      onPressed: () {
                        //tiene que enviar el nombre de las actividades marcadas con true
                        List<String> actsFiltre = [];
                        for (int i = 0; i < tipusActivitats.length; i++)
                          if (tipusActivitats[i].selected)
                            actsFiltre.add(tipusActivitats[i].nomActivity);
                        Navigator.of(context).pop(actsFiltre);
                      },
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

/*
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
                    Navigator.of(context).pop();
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
                ListView.builder(
                  itemCount: tipusActivitats.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Checkbox(
                        value: selected,
                        onChanged: (bool newValue) {
                          setState(() {
                            selected = newValue;
                          });
                        },
                      ),
                      title: Text('${tipusActivitats[index]}'),
                    );
                  },
                ),
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
                      onPressed: () {
                        //tiene que enviar el nombre de las actividades marcadas con true
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        )*/
