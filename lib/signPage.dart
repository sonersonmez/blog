import 'package:blog/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'globalpage.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController kullaniciAdi = TextEditingController();
  TextEditingController sifre = TextEditingController();

  Future<void> kayitOl() async{
    await FirebaseAuth.instance
    .createUserWithEmailAndPassword(email: kullaniciAdi.text, password: sifre.text)
    .then((kullanici) {
      FirebaseFirestore.instance.collection("Kullanicilar")
      .doc(kullaniciAdi.text)
      .set({"KullaniciEposta": kullaniciAdi.text,"KullaniciSifre": sifre.text});
    });
  }
  girisYap(){
    FirebaseAuth.instance
    .signInWithEmailAndPassword(email: kullaniciAdi.text, password: sifre.text)
    .then((value) =>  Navigator.pushAndRemoveUntil(context,
     MaterialPageRoute(builder:(context) => GlobalPage() ),
      (route) => false));
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: kullaniciAdi,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Your name here',
                labelText: 'Name *',
              ),
            ),
            TextFormField(
              controller: sifre,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Your password here',
                labelText: 'Password *',
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: girisYap,
                child: Text("Login")),
            ElevatedButton(onPressed: kayitOl, child: Text("Sign In")),
          ],
        ),
      ),
    );
  }
}
