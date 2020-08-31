import 'package:flutter/material.dart';
import 'package:santo_chope/sizer.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:provider/provider.dart';

class DialogTile extends StatefulWidget {
  final String userName;
  final String dateLastMessage;
  final String papoID;

  DialogTile(this.userName, this.dateLastMessage, this.papoID);

  @override
  _DialogTileState createState() => _DialogTileState();
}

class _DialogTileState extends State<DialogTile> {
  bool _clicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(Sizer.largu * 1.5),
        child: RaisedButton(
            elevation: 4.0,
            color: cinza,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: branco, width: 2),
              borderRadius: BorderRadius.circular(25),
            ),
            onPressed: () {
              DataManager.papoID = widget.papoID;
              Provider.of<DataManager>(context, listen: false).baterPapo();
            },
            child: Row(
              children: [
                _clicked ? SizedBox() : Icon(Icons.brightness_1, color: verde),
                Text(widget.userName),
                Text(widget.dateLastMessage)
              ],
            )));
  }
}
