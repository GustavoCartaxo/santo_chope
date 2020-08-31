import 'package:flutter/material.dart';
import 'package:santo_chope/sizer.dart';
import 'package:provider/provider.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:santo_chope/widgets/bottomBar.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:santo_chope/screens/batepapoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

bool firstTime = true;
final _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void printProducts() async {
    if (firstTime) {
      try {
        QuerySnapshot querySnapshot =
            await _firestore.collection('produtos').orderBy('position').get();
        querySnapshot.docs.forEach((document) async {
          String nome = await document.data()['nome'];
          String descricao = await document.data()['descricao'];
          String detalhe = await document.data()['detalhe'];
          double preco = await document.data()['preco'].toDouble();
          int estoque = await document.data()['estoque'];
          String imageName = await document.data()['imageName'];
          final ref = FirebaseStorage.instance.ref().child(imageName);
          var imageURL = await ref.getDownloadURL();
          Provider.of<DataManager>(context, listen: false).createProductTile(
              nome, descricao, preco, estoque, detalhe, imageURL);
        });
      } catch (e) {
        if (e.message != null) {
          print(e.message);
        }
      }
      Provider.of<DataManager>(context, listen: false)
          .addProduct2('APA Sotera', 'garrafa de 500ml', 18.00);
      Provider.of<DataManager>(context, listen: false)
          .addProduct2('IPA da Bonfim', 'garrafa de 500ml', 22.00);
      Provider.of<DataManager>(context, listen: false)
          .addProduct2('APA Sotera', 'garrafa de 500ml', 18.00);
      firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Sizer.setSize(MediaQuery.of(context).size.height / 100,
        MediaQuery.of(context).size.width / 100);
    printProducts();
    return ScreenManager();
  }
}

class ScreenManager extends StatefulWidget {
  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataManager>(
      builder: (context, batepapo, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Sizer.altu * 11.8),
            child: AppBar(
              leading: DataManager.batepapo
                  ? RawMaterialButton(
                      onPressed: () =>
                          Provider.of<DataManager>(context, listen: false)
                              .baterPapo(),
                      child: Icon(Icons.arrow_back_ios, size: Sizer.altu * 6))
                  : null,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                children: <Widget>[
                  SizedBox(height: Sizer.altu * 2.2),
                  Image.asset('assets/logolowres.png', height: Sizer.altu * 12),
                ],
              ),
              backgroundColor: amarelo,
              elevation: 5,
            ),
          ),
          body: DataManager.batepapo ? BatePapo() : BottomBar(),
          backgroundColor: amarelo,
        );
      },
    );
  }
}
