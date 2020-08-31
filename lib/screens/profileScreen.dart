import 'package:flutter/material.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:santo_chope/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
String email = '';
String password = '';
String nomeUser = '';
String cepUser = '';
String enderecoUser = '';
String errorMessage = '';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
    email = '';
    DataManager.register = false;
    DataManager.atualizar = false;
    errorMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<DataManager, DataManager, DataManager, DataManager>(
        builder: (context, atualizar, register, loggedIn, saving, child) {
      return ModalProgressHUD(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Sizer.largu * 10),
          color: amarelo,
          child: DataManager.atualizar
              ? AtualizaColumn()
              : DataManager.loggedIn
                  ? LogadoColumn()
                  : DataManager.register ? RegisterColumn() : LoginColumn(),
        ),
        inAsyncCall: DataManager.saving,
      );
    });
  }
}

//Coluna1
class LoginColumn extends StatefulWidget {
  @override
  _LoginColumnState createState() => _LoginColumnState();
}

class _LoginColumnState extends State<LoginColumn> {
  FocusNode _mailFocus;
  FocusNode _passwordFocus;
  FocusNode _buttonFocus;
  @override
  void initState() {
    super.initState();
    _mailFocus = FocusNode();
    _mailFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus = FocusNode();
    _passwordFocus.addListener(() {
      setState(() {});
    });
    _buttonFocus = FocusNode();
    _buttonFocus.addListener(() {
      setState(() {});
    });
  }

  void dispose() {
    _mailFocus.dispose();
    _passwordFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(height: Sizer.altu * 3),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizer.altu * 3),
          decoration: BoxDecoration(
              color: cinza,
              border: Border.all(color: branco, width: 3),
              borderRadius: BorderRadius.circular(15)),
          child: Column(children: <Widget>[
            SizedBox(height: Sizer.altu * 3),
            Container(
              decoration: BoxDecoration(
                  color: _mailFocus.hasFocus ? verde : preto,
                  border: Border.all(color: branco, width: 3),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                  cursorColor: branco,
                  style: TextStyle(
                    fontSize: Sizer.largu * 4,
                    fontWeight: FontWeight.w500,
                    color: branco,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _mailFocus,
                  onFieldSubmitted: (term) {
                    _mailFocus.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    hintText: 'E-mail',
                    hintStyle:
                        TextStyle(color: cinza, fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  )),
            ),
            SizedBox(height: Sizer.altu * 3),
            Container(
              decoration: BoxDecoration(
                  color: _passwordFocus.hasFocus ? verde : preto,
                  border: Border.all(color: branco, width: 3),
                  borderRadius: BorderRadius.circular(15)),
              child: TextFormField(
                  obscureText: true,
                  cursorColor: branco,
                  style: TextStyle(
                    fontSize: Sizer.largu * 4,
                    fontWeight: FontWeight.w500,
                    color: branco,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _passwordFocus,
                  onFieldSubmitted: (term) {
                    _passwordFocus.unfocus();
                    FocusScope.of(context).requestFocus(_buttonFocus);
                  },
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    hintText: 'Senha',
                    hintStyle:
                        TextStyle(color: cinza, fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  )),
            ),
            SizedBox(height: Sizer.altu * 3),
            RawMaterialButton(
              focusNode: _buttonFocus,
              fillColor: preto,
              focusColor: verde,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: branco, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              onPressed: () async {
                _passwordFocus.unfocus();
                Provider.of<DataManager>(context, listen: false).isSaving();
                if (email == null || password == null) {
                  setState(() {
                    errorMessage = 'Login não realizado:  Há algum campo vazio';
                  });
                } else
                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    var firebaseUser = _auth.currentUser;
                    if (firebaseUser != null) {
                      await _firestore
                          .collection('users')
                          .doc(firebaseUser.uid)
                          .get()
                          .then((value) {
                        if (value.exists) {
                          setState(() {
                            nomeUser = value.data()["nome"];
                            cepUser = value.data()["cep"];
                            enderecoUser = value.data()["adress"];
                          });
                        }
                      });
                      if (firebaseUser.email == 'gus@mail.com') {
                        Provider.of<DataManager>(context, listen: false)
                            .admOn();
                      }
                      Provider.of<DataManager>(context, listen: false).login();
                    }
                  } catch (e) {
                    if (e.message != null) {
                      setState(() {
                        errorMessage = 'Login não realizado:  ' + e.message;
                      });
                    }
                  }
                Provider.of<DataManager>(context, listen: false).isSaving();
              },
              child: Container(
                height: Sizer.altu * 3.5,
                width: Sizer.largu * 38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Icon(Icons.person, color: branco, size: Sizer.altu * 3),
                    Text('Login',
                        style: TextStyle(
                            fontFamily: 'Coiny',
                            fontSize: Sizer.largu * 4,
                            fontWeight: FontWeight.w300,
                            color: branco)),
                  ],
                ),
              ),
            ),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: Sizer.altu * 1.3),
          ]),
        ),
        SizedBox(height: Sizer.altu * 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: Sizer.largu * 20),
            RawMaterialButton(
                fillColor: preto,
                splashColor: verde,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: branco, width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                onPressed: () =>
                    Provider.of<DataManager>(context, listen: false)
                        .changeLoginScreen(),
                child: Container(
                  height: Sizer.altu * 3.5,
                  width: Sizer.largu * 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Novo Cervejeiro',
                          style: TextStyle(
                              fontFamily: 'Coiny',
                              fontSize: Sizer.largu * 4,
                              fontWeight: FontWeight.w300,
                              color: branco)),
                    ],
                  ),
                )),
          ],
        ),
      ]),
    );
  }
}

//Coluna2
class RegisterColumn extends StatefulWidget {
  @override
  _RegisterColumnState createState() => _RegisterColumnState();
}

class _RegisterColumnState extends State<RegisterColumn> {
  String nome;
  String cep;
  String adress;
  FocusNode _mailFocus;
  FocusNode _passwordFocus;
  FocusNode _cepFocus;
  FocusNode _adressFocus;
  FocusNode _nomeFocus;
  FocusNode _buttonFocus;

  @override
  void initState() {
    super.initState();
    _mailFocus = FocusNode();
    _mailFocus.addListener(() => setState(() {}));
    _passwordFocus = FocusNode();
    _passwordFocus.addListener(() => setState(() {}));
    _cepFocus = FocusNode();
    _cepFocus.addListener(() => setState(() {}));
    _adressFocus = FocusNode();
    _adressFocus.addListener(() => setState(() {}));
    _nomeFocus = FocusNode();
    _nomeFocus.addListener(() => setState(() {}));
    _buttonFocus = FocusNode();
    _buttonFocus.addListener(() => setState(() {}));
  }

  void dispose() {
    _mailFocus.dispose();
    _passwordFocus.dispose();
    _cepFocus.dispose();
    _adressFocus.dispose();
    _nomeFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: Sizer.altu * 1.4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizer.altu * 3),
          decoration: BoxDecoration(
              color: cinza,
              border: Border.all(color: branco, width: 3),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              SizedBox(height: Sizer.altu),
              Container(
                decoration: BoxDecoration(
                    color: _nomeFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _nomeFocus,
                    onFieldSubmitted: (term) {
                      _nomeFocus.unfocus();
                      FocusScope.of(context).requestFocus(_mailFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      nome = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'Nome',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 1),
              Container(
                decoration: BoxDecoration(
                    color: _mailFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    initialValue: email,
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    focusNode: _mailFocus,
                    onFieldSubmitted: (term) {
                      _mailFocus.unfocus();
                      FocusScope.of(context).requestFocus(_cepFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'E-mail',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 1),
              Container(
                decoration: BoxDecoration(
                    color: _cepFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _cepFocus,
                    onFieldSubmitted: (term) {
                      _cepFocus.unfocus();
                      FocusScope.of(context).requestFocus(_adressFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      cep = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'CEP',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 1),
              Container(
                decoration: BoxDecoration(
                    color: _adressFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _adressFocus,
                    onFieldSubmitted: (term) {
                      _adressFocus.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      adress = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'Endereço de Entrega',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 1),
              Container(
                decoration: BoxDecoration(
                    color: _passwordFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    obscureText: true,
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    focusNode: _passwordFocus,
                    onFieldSubmitted: (term) {
                      _passwordFocus.unfocus();
                      FocusScope.of(context).requestFocus(_buttonFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'Senha',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 0.4),
              RawMaterialButton(
                  fillColor: preto,
                  focusColor: verde,
                  focusNode: _buttonFocus,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: branco, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: () async {
                    if (nome == null ||
                        email == null ||
                        cep == null ||
                        adress == null ||
                        password == null) {
                      setState(() {
                        errorMessage =
                            'Cadastro não realizado:  Há algum campo vazio';
                      });
                    } else {
                      Provider.of<DataManager>(context, listen: false)
                          .isSaving();
                      try {
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        var firebaseUser = _auth.currentUser;
                        await _firestore
                            .collection('users')
                            .doc(firebaseUser.uid)
                            .set({
                          'nome': nome,
                          'mail': email,
                          'cep': cep,
                          'adress': adress,
                          'lastMessage': DateTime.now().toIso8601String(),
                        });
                        nomeUser = nome;
                        cepUser = cep;
                        enderecoUser = adress;
                        Provider.of<DataManager>(context, listen: false)
                            .login();
                      } catch (e) {
                        setState(() {
                          errorMessage =
                              'Cadastro não realizado:  ' + e.message;
                        });
                      }
                      Provider.of<DataManager>(context, listen: false)
                          .isSaving();
                    }
                  },
                  child: Container(
                    height: Sizer.altu * 3.5,
                    width: Sizer.largu * 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Registrar',
                          style: TextStyle(
                            fontFamily: 'Coiny',
                            fontSize: Sizer.largu * 4,
                            fontWeight: FontWeight.w300,
                            color: branco,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  )),
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}

//Coluna3
class LogadoColumn extends StatefulWidget {
  @override
  _LogadoColumnState createState() => _LogadoColumnState();
}

class _LogadoColumnState extends State<LogadoColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: Sizer.altu * 5),
        Text('Olá, ' + nomeUser + '!',
            style: TextStyle(
                fontFamily: 'Coiny',
                fontSize: Sizer.largu * 4,
                fontWeight: FontWeight.w300,
                color: branco,
                letterSpacing: 2)),
        SizedBox(height: Sizer.altu * 2),
        Text('Seu endereço de entrega é:',
            style: TextStyle(
                fontFamily: 'Coiny',
                fontSize: Sizer.largu * 3,
                fontWeight: FontWeight.w200,
                color: preto,
                letterSpacing: 1.5)),
        SizedBox(height: Sizer.altu * 2),
        Text(enderecoUser,
            style: TextStyle(
                fontFamily: 'Coiny',
                fontSize: Sizer.largu * 4,
                fontWeight: FontWeight.w300,
                color: branco,
                letterSpacing: 2)),
        SizedBox(height: Sizer.altu * 2),
        Text('Seu CEP:',
            style: TextStyle(
                fontFamily: 'Coiny',
                fontSize: Sizer.largu * 3,
                fontWeight: FontWeight.w200,
                color: preto,
                letterSpacing: 1.5)),
        SizedBox(height: Sizer.altu * 2),
        Text(cepUser,
            style: TextStyle(
                fontFamily: 'Coiny',
                fontSize: Sizer.largu * 4,
                fontWeight: FontWeight.w300,
                color: branco,
                letterSpacing: 2)),
        SizedBox(height: Sizer.altu * 6),
        RawMaterialButton(
            fillColor: preto,
            onPressed: () =>
                Provider.of<DataManager>(context, listen: false).atualizate(),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: branco, width: 2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: Sizer.largu * 38,
              height: Sizer.altu * 3.5,
              child: Center(
                child: Text('Alterar',
                    style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: Sizer.largu * 4,
                        fontWeight: FontWeight.w300,
                        color: branco,
                        letterSpacing: 2)),
              ),
            )),
        SizedBox(height: Sizer.altu * 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: Sizer.largu * 20),
            RawMaterialButton(
                fillColor: preto,
                onPressed: () async {
                  Provider.of<DataManager>(context, listen: false).isSaving();
                  try {
                    await _auth.signOut();
                    Provider.of<DataManager>(context, listen: false).login();
                  } catch (e) {}
                  Provider.of<DataManager>(context, listen: false).isSaving();
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: branco, width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  width: Sizer.largu * 38,
                  height: Sizer.altu * 3.5,
                  child: Center(
                    child: Text('Logout',
                        style: TextStyle(
                            fontFamily: 'Coiny',
                            fontSize: Sizer.largu * 4,
                            fontWeight: FontWeight.w300,
                            color: branco)),
                  ),
                ))
          ],
        )
      ],
    );
  }
}

//Coluna4
class AtualizaColumn extends StatefulWidget {
  @override
  _AtualizaColumnState createState() => _AtualizaColumnState();
}

class _AtualizaColumnState extends State<AtualizaColumn> {
  String nome;
  String cep;
  String adress;
  FocusNode _cepFocus;
  FocusNode _adressFocus;
  FocusNode _nomeFocus;
  FocusNode _buttonFocus;

  @override
  void initState() {
    super.initState();
    nome = nomeUser;
    adress = enderecoUser;
    cep = cepUser;
    _cepFocus = FocusNode();
    _cepFocus.addListener(() => setState(() {}));
    _adressFocus = FocusNode();
    _adressFocus.addListener(() => setState(() {}));
    _nomeFocus = FocusNode();
    _nomeFocus.addListener(() => setState(() {}));
    _buttonFocus = FocusNode();
    _buttonFocus.addListener(() => setState(() {}));
  }

  void dispose() {
    _cepFocus.dispose();
    _adressFocus.dispose();
    _nomeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: Sizer.altu * 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Sizer.altu * 3),
          decoration: BoxDecoration(
              color: cinza,
              border: Border.all(color: branco, width: 3),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: Sizer.altu * 3),
              Container(
                decoration: BoxDecoration(
                    color: _nomeFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    initialValue: nomeUser,
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _nomeFocus,
                    onFieldSubmitted: (term) {
                      _nomeFocus.unfocus();
                      FocusScope.of(context).requestFocus(_adressFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      nome = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'Nome',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 2),
              Container(
                decoration: BoxDecoration(
                    color: _adressFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    initialValue: enderecoUser,
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    focusNode: _adressFocus,
                    onFieldSubmitted: (term) {
                      _adressFocus.unfocus();
                      FocusScope.of(context).requestFocus(_cepFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      adress = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'Endereço',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 2),
              Container(
                decoration: BoxDecoration(
                    color: _cepFocus.hasFocus ? verde : preto,
                    border: Border.all(color: branco, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                    initialValue: cepUser,
                    cursorColor: branco,
                    style: TextStyle(
                      fontSize: Sizer.largu * 4,
                      fontWeight: FontWeight.w500,
                      color: branco,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    focusNode: _cepFocus,
                    onFieldSubmitted: (term) {
                      _cepFocus.unfocus();
                      FocusScope.of(context).requestFocus(_buttonFocus);
                    },
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      cep = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      hintText: 'CEP',
                      hintStyle:
                          TextStyle(color: cinza, fontWeight: FontWeight.w300),
                      border: InputBorder.none,
                    )),
              ),
              SizedBox(height: Sizer.altu * 3),
              RawMaterialButton(
                  focusNode: _buttonFocus,
                  fillColor: preto,
                  focusColor: verde,
                  onPressed: () async {
                    Provider.of<DataManager>(context, listen: false).isSaving();
                    try {
                      var firebaseUser = _auth.currentUser;
                      await _firestore
                          .collection('users')
                          .doc(firebaseUser.uid)
                          .update({
                        'nome': nome,
                        'cep': cep,
                        'adress': adress,
                      });
                      nomeUser = nome;
                      cepUser = cep;
                      enderecoUser = adress;
                      Provider.of<DataManager>(context, listen: false)
                          .atualizate();
                    } catch (e) {
                      setState(() {
                        errorMessage =
                            'Atualização não realizada:  ' + e.message;
                      });
                    }
                    Provider.of<DataManager>(context, listen: false).isSaving();
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: branco, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    width: Sizer.largu * 38,
                    height: Sizer.altu * 3.5,
                    child: Center(
                      child: Text('Alterar',
                          style: TextStyle(
                              fontFamily: 'Coiny',
                              fontSize: Sizer.largu * 4,
                              fontWeight: FontWeight.w300,
                              color: branco,
                              letterSpacing: 2)),
                    ),
                  )),
              Text(errorMessage, style: TextStyle(color: Colors.red)),
              SizedBox(height: Sizer.altu * 1.3),
            ],
          ),
        ),
      ],
    );
  }
}
