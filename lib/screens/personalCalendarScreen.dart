//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/model/activitat.dart';
import 'activityScreen.dart';

Map<String, Color> colorsActivitat = {
  'Spinning': Colors.purple[100],
  'Calistenia': Colors.indigo,
  'Kickboxing': Colors.blueAccent,
  'Ioga': Colors.amber,
  'Crossfit': Colors.green[300]
};

class PersonalCalendarScreen extends StatelessWidget {
  const PersonalCalendarScreen({
    Key key,
    this.docs,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> docs;

  @override
  Widget build(BuildContext context) {
    final activitats = FirebaseFirestore.instance.collection(
        'Activitats'); //recollim dades de firebase amb les activitats
    //FirebaseDatabase.getInstance().

    final inscripcionsUser = FirebaseFirestore.instance
        .collection('Usuaris')
        .doc(
            '${FirebaseAuth.instance.currentUser.uid}') // '${FirebaseAuth.instance.currentUser}'//'c5Dz89sXkUZ7s77yI8pdPQ6s0Nz1'
        .collection(
            'inscripcions'); //recollim les dades de les inscripcions , en aquest cas nomes d`un usuari

    return StreamBuilder(
        stream: inscripcionsUser.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final inscripcionsDocs =
              snapshot.data.docs; //LLISTA DE CODIS ACT INSCRITES USUARI

          return StreamBuilder(
              stream: activitats.orderBy('inici').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final actsDocs =
                    snapshot.data.docs; //LLISTA D'ACT EXISTENTS AL GIMNÀS
                final llistaActCompletes = [];

                for (int i = 0; i < inscripcionsDocs.length; i++) {
                  //// filtre per encreuar les dades de les 2 coleccions
                  for (int j = 0; j < actsDocs.length; j++) {
                    if (inscripcionsDocs[i].id == actsDocs[j].id) {
                      llistaActCompletes.add(actsDocs[
                          j]); //CREEM UNA LLISTA AMB LA INFO DE LES ACTIVITATS INSCRITES
                    }
                  }
                }

                return ListView.builder(
                  itemCount: llistaActCompletes.length,
                  itemBuilder: (context, index) {
                    final item = llistaActCompletes[index];

                    return ActivitatInscrita(item: item);
                  },
                );
              });
        });
  }
}

class ActivitatInscrita extends StatefulWidget {
  const ActivitatInscrita({
    Key key,
    @required this.item,
  }) : super(key: key);

  final item;

  @override
  _ActivitatInscritaState createState() => _ActivitatInscritaState();
}

class _ActivitatInscritaState extends State<ActivitatInscrita> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 90,
        child: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  widget.item['inici'].toDate().day.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('/'),
                Text(
                  widget.item['inici'].toDate().month.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(' de '),
                Text(
                  widget.item['inici'].toDate().hour.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(' a '),
                Text(
                  widget.item['final'].toDate().hour.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
              SizedBox(
                height: 3,
              ),
              Text(widget.item['tipus']),
              SizedBox(
                height: 3,
              ),
              Text(
                widget.item['lloc'],
                style: TextStyle(color: Colors.grey[500]),
              )
            ],
          ),
          trailing: FlatButton(
            child: Icon(Icons.remove),
            onPressed: () {
              //OPCIÓN 2: (AL VOLVER A LA PANTALLA ANTIGUA SE BLOQUEA LA APP)
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return ActivityScreen(
                          Activitat(
                            widget.item['tipus'],
                            widget.item['inici'].toDate(),
                            widget.item['final'].toDate(),
                            widget.item['lloc'],
                            widget.item['entrenador'],
                            widget.item['max_assis'],
                            widget.item['num_assis'],
                            widget.item.id,
                          ),
                          true);
                    },
                  ));
              //OPCIÓN 1 : (SE PONE LA PANTALLA NEGRA)
              /*Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ActivityScreen(
                        Activitat(
                          widget.item['tipus'],
                          widget.item['inici'].toDate(),
                          widget.item['final'].toDate(),
                          widget.item['lloc'],
                          widget.item['entrenador'],
                          widget.item['max_assis'],
                          widget.item['num_assis'],
                        ),
                        true), //mandamos la actividad 'seleccionada'
                  ),
                )*/
              //TENDREMOS QUE PONER EL THEN
            },
          ),
          leading: Container(
            width: 80,
            child: Image.asset(
              '${widget.item['tipus']}.png',
              fit: BoxFit.contain,
              color: colorsActivitat[widget.item['tipus']],
            ),
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: new Offset(0.0, 1.0),
              blurRadius: 50.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

/*Firestore.instance.runTransaction((transaction) async {
      await transaction
          .set(documentReference, {
            'last_name': map['last_name'],
            'first_name': map['first_name'],
            'middle_name': map['middle_name']
          })
          .catchError((e) {})
          .whenComplete(() {});
    }).catchError((e) {
      return false;
    });
    




    var sfDocRef = db.collection("cities").doc("SF");

db.runTransaction(function(transaction) {
    return transaction.get(sfDocRef).then(function(sfDoc) {
        if (!sfDoc.exists) {
            throw "Document does not exist!";
        }

        var newPopulation = sfDoc.data().population + 1;
        if (newPopulation <= 1000000) {
            transaction.update(sfDocRef, { population: newPopulation });
            return newPopulation;
        } else {
            return Promise.reject("Sorry! Population is too big.");
        }
    });
}).then(function(newPopulation) {
    console.log("Population increased to ", newPopulation);
}).catch(function(err) {
    // This will be an "population is too big" error.
    console.error(err);
});
    */


/*
class _FilmListState extends State<FilmList> {
  String _filterOrSort = "sort_year";

  _FilmListState();

  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('firestore-example-app');

    void _onActionSelected(String value) async {
      if (value == "batch_reset_likes") {
        WriteBatch batch = FirebaseFirestore.instance.batch(); //////////////////////////////////

        await query.get().then((querySnapshot) async {
          querySnapshot.docs.forEach((document) {
            batch.update(document.reference, {'likes': 0});
          });

          await batch.commit();

          setState(() {
            _filterOrSort = "sort_year";
          });
        });
      } else {
        setState(() {
          _filterOrSort = value;
        });
      }
    }

    switch (_filterOrSort) {
      case "sort_year":

        /// Order by the production year. Set [descending] to [false] to reverse the order
        query = query.orderBy('year', descending: true);
        break;
      case "sort_likes_desc":

        /// Order by the number of likes. Set [descending] to [false] to reverse the order
        query = query.orderBy('likes', descending: true);
        break;
      case "sort_likes_asc":

        /// Order by the number of likes. Set [descending] to [false] to reverse the order
        query = query.orderBy('likes', descending: false);
        break;
      case "sort_score":

        /// Order by the score, and return only those which has one great than 90
        query = query.orderBy('score').where('score', isGreaterThan: 90);
        break;
      case "filter_genre_scifi":

        /// Return the movies which have the following categories
        query = query.where('genre', arrayContainsAny: ['Sci-Fi']);
        break;
      case "filter_genre_fantasy":

        /// Return the movies which have the following categories
        query = query.where('genre', arrayContainsAny: ['Fantasy']);
        break;
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Firestore Example: Movies'),

              // This is a example use for "snapshots in sync".
              // The view reflects the time of the last Firestore sync; which happens any time a field is updated.
              StreamBuilder(
                stream: FirebaseFirestore.instance.snapshotsInSync(),
                builder: (context, _) {
                  return Text(
                    'Latest Snapshot: ${DateTime.now()}',
                    style: Theme.of(context).textTheme.caption,
                  );
                },
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (String value) async {
                await _onActionSelected(value);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "sort_year",
                    child: Text("Sort by Year"),
                  ),
                  PopupMenuItem(
                    value: "sort_score",
                    child: Text("Sort by Score"),
                  ),
                  PopupMenuItem(
                    value: "sort_likes_asc",
                    child: Text("Sort by Likes ascending"),
                  ),
                  PopupMenuItem(
                    value: "sort_likes_desc",
                    child: Text("Sort by Likes descending"),
                  ),
                  PopupMenuItem(
                    value: "filter_genre_fantasy",
                    child: Text("Filter genre Fantasy"),
                  ),
                  PopupMenuItem(
                    value: "filter_genre_scifi",
                    child: Text("Filter genre Sci-Fi"),
                  ),
                  PopupMenuItem(
                    value: "batch_reset_likes",
                    child: Text("Reset like counts (WriteBatch)"),
                  ),
                ];
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder: (context, stream) {
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
              itemCount: querySnapshot.size,
              itemBuilder: (context, index) => Movie(querySnapshot.docs[index]),
            );
          },
        ));
  }
}

/// A single movie row.
class Movie extends StatelessWidget {
  /// Contains all snapshot data for a given movie.
  final DocumentSnapshot snapshot;

  /// Initialize a [Move] instance with a given [DocumentSnapshot].
  Movie(this.snapshot);

  /// Returns the [DocumentSnapshot] data as a a [Map].
  Map<String, dynamic> get movie {
    return snapshot.data();
  }

  /// Returns the movie poster.
  Widget get poster {
    return Container(
      width: 100,
      child: Center(child: Image.network(movie['poster'])),
    );
  }

  /// Returns movie details.
  Widget get details {
    return Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            metadata,
            genres,
            Likes(
              reference: snapshot.reference,
              currentLikes: movie['likes'],
            )
          ],
        ));
  }

  /// Return the movie title.
  Widget get title {
    return Text("${movie['title']} (${movie['year']})",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  /// Returns metadata about the movie.
  Widget get metadata {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Row(children: [
          Padding(
              child: Text('Rated: ${movie['rated']}'),
              padding: EdgeInsets.only(right: 8)),
          Text('Runtime: ${movie['runtime']}'),
        ]));
  }

  /// Returns a list of genre movie tags.
  List<Widget> genreItems() {
    List<Widget> items = <Widget>[];
    movie['genre'].forEach((genre) {
      items.add(Padding(
        child: Chip(
            label: Text(genre, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.lightBlue),
        padding: EdgeInsets.only(right: 2),
      ));
    });
    return items;
  }

  /// Returns all genres.
  Widget get genres {
    return Padding(
        padding: EdgeInsets.only(top: 8), child: Wrap(children: genreItems()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4, top: 4),
        child: Container(
          child: Row(
            children: [poster, Flexible(child: details)],
          ),
        ));
  }
}

/// Displays and manages the movie "like" count.
class Likes extends StatefulWidget {
  /// The [DocumentReference] relating to the counter.
  final DocumentReference /*!*/ reference;

  /// The number of current likes (before manipulation).
  final num /*!*/ currentLikes;

  /// Constructs a new [Likes] instance with a given [DocumentReference] and
  /// current like count.
  Likes({Key key, this.reference, this.currentLikes}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Likes();
  }
}

class _Likes extends State<Likes> {
  int /*!*/ _likes;

  _onLike(int current) async {
    // Increment the "like" count straight away to show feedback to the user.
    setState(() {
      _likes = current + 1;
    });

    try {
      // Return and set the updated "likes" count from the transaction
      int newLikes = await FirebaseFirestore.instance                 /////////////////////////////////////////
          .runTransaction<int>((transaction) async {
        DocumentSnapshot txSnapshot = await transaction.get(widget.reference);

        if (!txSnapshot.exists) {
          throw Exception("Document does not exist!");
        }

        int updatedLikes = (txSnapshot.data()['likes'] ?? 0) + 1;
        transaction.update(widget.reference, {'likes': updatedLikes});
        return updatedLikes;
      });

      // Update with the real count once the transaction has completed.
      setState(() {
        _likes = newLikes;
      });
    } catch (e, s) {
      print(s);
      print("Failed to update likes for document! $e");

      // If the transaction fails, revert back to the old count
      setState(() {
        _likes = current;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentLikes = _likes ?? widget.currentLikes ?? 0;

    return Row(children: [
      IconButton(
          icon: Icon(Icons.favorite),
          iconSize: 20,
          onPressed: () {
            _onLike(currentLikes);
          }),
      Text("$currentLikes likes"),
    ]);
  }
}*/
