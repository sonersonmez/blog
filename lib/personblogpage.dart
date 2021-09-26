import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonBlogPage extends StatefulWidget {
  const PersonBlogPage({ Key? key }) : super(key: key);

  @override
  _PersonBlogPageState createState() => _PersonBlogPageState();
}

class _PersonBlogPageState extends State<PersonBlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Blog Yazılarınız")),
    );
  }
}

//-----------
class PersonalBlogPageDatas extends StatefulWidget {
  @override
    _PersonalBlogPageDatas createState() => _PersonalBlogPageDatas();
}

class _PersonalBlogPageDatas extends State<PersonalBlogPageDatas> {
  final Stream<QuerySnapshot> _usersStream =
   FirebaseFirestore.instance.collection('Yazilar').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['baslik']),
              subtitle: Text(data['icerik']),
            );
          }).toList(),
        );
      },
    );
  }
}