import 'package:cloud_firestore/cloud_firestore.dart';

class Activitat {
  String nom, entrenador, sala, id;
  DateTime dataInici, dataFinal;
  int max_assis, num_assis;
  bool inscrita = false;
  //List assistents;

  Activitat(this.nom, this.dataInici, this.dataFinal, this.sala, this.entrenador, this.max_assis,
      this.num_assis, this.id
      //{this.assistents}
      );
}

Stream<List<Activitat>> llistaActivitats() {
  final activitats = FirebaseFirestore.instance.collection('Activitats').orderBy('inici');
  //.where('inici', isGreaterThanOrEqualTo: weekStart);

  return activitats.snapshots().map((querySnapshot) {
    List<Activitat> result = [];
    for (var activitatSnapshot in querySnapshot.docs) {
      result.add(Activitat(
        activitatSnapshot['tipus'],
        activitatSnapshot['inici'].toDate(),
        activitatSnapshot['final'].toDate(),
        activitatSnapshot['lloc'],
        activitatSnapshot['entrenador'],
        activitatSnapshot['max_assis'],
        activitatSnapshot['num_assis'],
        activitatSnapshot.id,
        //Peta aquí
        //assistents: a['assistents'],
      ));
    }
    return result;
  });
}
