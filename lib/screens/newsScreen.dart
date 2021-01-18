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

              return CollapsibleNew(item);
            },
          );
        });
  }
}

class CollapsibleNew extends StatefulWidget {
  final item;
  CollapsibleNew(this.item);
  @override
  _CollapsibleNewState createState() => _CollapsibleNewState();
}

class _CollapsibleNewState extends State<CollapsibleNew> {
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
        padding: const EdgeInsets.only(top: 8),
        height: (_expanded ? null : 120),
        child: ListTile(
          title: Text(
            widget.item['titol'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.item['contingut'],
                  maxLines: (_expanded ? null : 2),
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                FlatButton(
                  child:
                      Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.warning_amber_rounded,
            color: chooseColor(widget.item['rellevancia']),
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[350],
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
