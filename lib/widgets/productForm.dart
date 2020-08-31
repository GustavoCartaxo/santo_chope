import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangerProduct extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productID;
  final bool add;

  ChangerProduct(this.productName, this.productDescription, this.productPrice,
      this.productID, this.add);

  @override
  _ChangerProductState createState() => _ChangerProductState();
}

class _ChangerProductState extends State<ChangerProduct> {
  String errorMessage = '';
  String nomeProduto;
  String descricao;
  double preco;
  double position;
  int estoque;
  String descricaoDetalhada;
  String idProduto;
  File imageFile;
  bool _saving;
  final picker = ImagePicker();
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nomeProduto = widget.productName;
    descricao = widget.productDescription;
    preco = widget.productPrice;
  }

  void _openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

  Future uploadFile(String nameImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(nameImage);
    await storageReference.delete();
    final StorageUploadTask uploadTask2 = storageReference.putFile(imageFile);
    await uploadTask2.onComplete;
  }

  Future deleteFile(String nameImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(nameImage);
    await storageReference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Container(
        color: Color.fromARGB(255, 116, 92, 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.productName,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Nome do Produto',
                ),
                onChanged: (value) {
                  nomeProduto = value;
                },
              ),
              TextFormField(
                initialValue: widget.productDescription,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Descrição do Produto',
                ),
                onChanged: (value) {
                  descricao = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Descrição Detalhada',
                ),
                onChanged: (value) {
                  descricaoDetalhada = value;
                },
              ),
              TextFormField(
                initialValue: widget.productPrice.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Preço do Produto',
                ),
                onChanged: (value) {
                  preco = double.parse(value);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Posição do Produto na Lista',
                ),
                onChanged: (value) {
                  position = double.parse(value);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Quantidade em Estoque',
                ),
                onChanged: (value) {
                  estoque = int.parse(value);
                },
              ),
              FlatButton(
                  onPressed: () => _openGallery(),
                  child: Text('Escolha Imagem')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      if (nomeProduto == null ||
                          descricao == null ||
                          preco == null ||
                          descricaoDetalhada == null ||
                          position == null ||
                          estoque == null) {
                        setState(() {
                          errorMessage =
                              'Cadastro não realizado:  Há algum campo vazio';
                        });
                      } else {
                        _saving = true;
                        try {
                          await _firestore
                              .collection('produtos')
                              .doc(idProduto)
                              .set({
                            'nome': nomeProduto,
                            'descricao': descricao,
                            'detalhe': descricaoDetalhada,
                            'preco': preco,
                            'position': position,
                            'estoque': estoque,
                          });
                          await uploadFile(idProduto);
                        } catch (e) {
                          setState(() {
                            errorMessage =
                                'Cadastro não realizado:  ' + e.message;
                          });
                        }
                        _saving = false;
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Atualizar Produto'),
                  ),
                  RaisedButton(
                      onPressed: () async {
                        _saving = true;
                        try {
                          await _firestore
                              .collection('produtos')
                              .doc(idProduto)
                              .delete();
                          await deleteFile(idProduto);
                        } catch (e) {
                          setState(() {
                            errorMessage =
                                'Produto não deletado:  ' + e.message;
                          });
                        }
                        _saving = false;
                        Navigator.pop(context);
                      },
                      child: Text('Deletar Produto'))
                ],
              ),
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
