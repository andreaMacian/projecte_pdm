import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = FirebaseFirestore.instance.collection('News');
    return StreamBuilder(
        stream: news.orderBy('data_public', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final newsDocs = snapshot.data.docs;

          return ListView.builder(
            itemCount: newsDocs.length,
            itemBuilder: (context, index) {
              final item = newsDocs[index];
              //bool _expanded = false;

              return collapsibleNew(item);
              /*Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: (_expanded ? null : 90),
                  child: ListTile(
                    title: Text(
                      item['titol'],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item['contingut'],
                          maxLines: (_expanded ? null : 2),
                        ),
                        FlatButton(
                          child: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                          onPressed: () {/*
                            setState(() {
                              _expanded = !_expanded;
                            });*/
                          },
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.warning_outlined,
                      color: chooseColor(item['rellevancia']),
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
              );*/
            },
          );
        });
  }

  /*Color chooseColor(int rellevancia) {
    if (rellevancia == 1) return Colors.green;
    if (rellevancia == 2)
      return Colors.yellow;
    else {
      return Colors.red;
    }
  }*/
}

class collapsibleNew extends StatefulWidget {
  final item;
  collapsibleNew(this.item);
  @override
  _collapsibleNewState createState() => _collapsibleNewState();
}

class _collapsibleNewState extends State<collapsibleNew> {
  bool _expanded = false;

  Color chooseColor(int rellevancia) {
    if (rellevancia == 1) return Colors.green;
    if (rellevancia == 2)
      return Colors.yellow;
    else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: (_expanded ? null : 90),
        child: ListTile(
          title: Text(
            widget.item['titol'],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.item['contingut'],
                maxLines: (_expanded ? null : 2),
              ),
              FlatButton(
                child: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ],
          ),
          trailing: Icon(
            Icons.warning_outlined,
            color: chooseColor(widget.item['rellevancia']),
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
