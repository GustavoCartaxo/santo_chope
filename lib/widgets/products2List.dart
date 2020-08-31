import 'package:flutter/material.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:santo_chope/sizer.dart';

class Products2List extends StatelessWidget {
  const Products2List({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            DataManager.products2.isEmpty
                ? Center(child: Text('Carregando Produtos'))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return DataManager.products2[index];
                    },
                    itemCount: DataManager.products2.length),
            SizedBox(height: Sizer.altu * 30),
          ],
        ));
  }
}
