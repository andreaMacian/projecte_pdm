import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final news = FirebaseFirestore.instance.collection('News');
    // return StreamBuilder(
    //     stream: news.snapshots(),
    //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       final news_docs = snapshot.data.docs;
    //       ListView.builder(
    //         itemCount: news_docs.length,
    //         itemBuilder: (context, index) {
    //           final item = news_docs[index];
    //           return ListTile(
    //             title: Text(
    //               item['titol'],
    //             ),
    //           );
    //         },
    //       );
    //     });

return Container(
  child: Text('NOTICIES'),
);


  }
}
