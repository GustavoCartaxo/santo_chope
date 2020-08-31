import 'package:flutter/material.dart';
import 'package:santo_chope/sizer.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;
String dialogID;
final messageTextController = TextEditingController();
String messageText;
bool logado = false;
ScrollController _scrollController = new ScrollController();

class BatePapo extends StatefulWidget {
  @override
  _BatePapoState createState() => _BatePapoState();
}

class _BatePapoState extends State<BatePapo> {
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          dialogID = loggedInUser.uid;
          logado = true;
        });
      } else {
        setState(() {
          logado = false;
        });
      }
    } catch (e) {
      print(e);
      logado = false;
    }
    if (Provider.of<DataManager>(context, listen: false).checkadm())
      dialogID = DataManager.papoID;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: branco,
                border: Border.all(color: cinza, width: 3),
                borderRadius: BorderRadius.circular(15)),
            child: !logado
                ? Text('Você não está logado')
                : Column(children: <Widget>[
                    MessagesStream(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: Sizer.largu * 80,
                          height: Sizer.altu * 6,
                          child: TextField(
                            onTap: () {
                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            cursorColor: preto,
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: amarelo, width: 2)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                hintText: 'Escreva uma mensagem',
                                hintStyle: TextStyle(color: cinza)),
                          ),
                        ),
                        RawMaterialButton(
                            onPressed: () {
                              messageTextController.clear();
                              _fireStore
                                  .collection('users')
                                  .doc(dialogID)
                                  .collection('papo')
                                  .add({
                                'text': messageText,
                                'sender': Provider.of<DataManager>(context,
                                            listen: false)
                                        .checkadm()
                                    ? 'Peu'
                                    : loggedInUser.email,
                                'time': DateTime.now().toIso8601String(),
                              });
                              _fireStore
                                  .collection('users')
                                  .doc(dialogID)
                                  .update({
                                'lastMessage': DateTime.now().toIso8601String(),
                              });
                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            child: Text('Enviar'))
                      ],
                    ),
                  ])),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('users')
          .doc(dialogID)
          .collection('papo')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        }
        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final currentUser =
              Provider.of<DataManager>(context, listen: false).checkadm()
                  ? 'Peu'
                  : loggedInUser.email;
          final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: isMe ? Colors.yellow : amarelo,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
