import 'package:flutter/material.dart';
import 'package:santo_chope/widgets/dialogTileAdm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<DialogTile> papos = [];
bool firstTime = true;
final _firestore = FirebaseFirestore.instance;

class DialogsManager extends StatefulWidget {
  @override
  _DialogsManagerState createState() => _DialogsManagerState();
}

class _DialogsManagerState extends State<DialogsManager> {
  void printPapos() async {
    if (firstTime) {
      try {
        QuerySnapshot querySnapshot =
            await _firestore.collection('users').orderBy('position').get();
        querySnapshot.docs.forEach((document) async {
          String nome = await document.data()['nome'];
          String last = await document.data()['lastMessage'];
          String papoID = document.id;
          papos.add(new DialogTile(nome, last, papoID));
        });
      } catch (e) {
        if (e.message != null) {
          print(e.message);
        }
      }

      firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    printPapos();
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            papos.isEmpty
                ? Center(child: Text('Carregando Papos'))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return papos[index];
                    },
                    itemCount: papos.length),
          ],
        ));
  }
}
