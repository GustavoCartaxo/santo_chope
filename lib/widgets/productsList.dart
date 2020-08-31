import 'package:flutter/material.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:santo_chope/sizer.dart';
import 'package:provider/provider.dart';
import 'productForm.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            DataManager.products.isEmpty
                ? Center(child: Text('Carregando produtos'))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return DataManager.products[index];
                    },
                    itemCount: DataManager.products.length),
            Provider.of<DataManager>(context, listen: false).checkadm()
                ? RaisedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) =>
                            ChangerProduct("", "", 5.00, "", true),
                      );
                    },
                    child: Text('Adicionar Produto'))
                : SizedBox(height: Sizer.altu * 30)
          ],
        ));
  }
}
