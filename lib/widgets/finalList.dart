import 'package:flutter/material.dart';
import 'package:santo_chope/dataManager.dart';

class FinalList extends StatelessWidget {
  const FinalList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return DataManager.finals[index];
        },
        itemCount: DataManager.finals.length);
  }
}
