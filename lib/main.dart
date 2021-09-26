import 'package:blog/personblogpage.dart';
import 'package:blog/profile.dart';
import 'package:blog/signPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignPage(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  TextEditingController baslikController = TextEditingController();
  TextEditingController icerikController = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  yaziEkle() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(baslikController.text)
        .set({
        "kullaniciid": auth.currentUser!.uid,
      "baslik": baslikController.text,
      "icerik": icerikController.text
    }).whenComplete(() => print("Kaydınız eklendi."));
  }

  yaziGuncelle() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(baslikController.text)
        .update({
      "baslik": baslikController.text,
      "icerik": icerikController.text
    }).whenComplete(() => print("Yazı güncellendi."));
  }

  yaziSil() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(baslikController.text)
        .delete()
        .whenComplete(() => print("Silindi."));
  }

  yaziGoster() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(baslikController.text)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()?['baslik'] ?? -1;
        gelenYaziBasligi = gelenVeri.data()?['icerik'] ?? -1;
      });
    });
  }

  cikisYap() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignPage()),
            (route) => false));
  }
  profilSayfayisinaGit(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonBlogPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: cikisYap, icon: Icon(Icons.exit_to_app)),
          IconButton(onPressed: profilSayfayisinaGit, icon: Icon(Icons.person_pin_outlined))
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(50),
          child: Column(
            children: [
              TextField(
                controller: baslikController,
              ),
              TextField(
                controller: icerikController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: yaziEkle, child: Text("Ekle")),
                  ElevatedButton(
                      onPressed: yaziGuncelle, child: Text("Güncelle")),
                  ElevatedButton(onPressed: yaziSil, child: Text("Sil")),
                  ElevatedButton(
                      onPressed: yaziGoster, child: Text("Yazı Getir")),
                ],
              ),
              ListTile(
                title: Text(gelenYaziBasligi),
                subtitle: Text(gelenYaziIcerigi),
              ),
            ],
          ),
        ),
      ),
    );
  }
}