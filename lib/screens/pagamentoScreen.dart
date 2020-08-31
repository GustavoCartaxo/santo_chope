import 'package:flutter/material.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:santo_chope/sizer.dart';
import 'package:santo_chope/widgets/finalList.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:provider/provider.dart';
import 'dialogManager.dart';

class PagamentoScreen extends StatefulWidget {
  const PagamentoScreen({Key key}) : super(key: key);

  @override
  _PagamentoScreenState createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  @override
  Widget build(BuildContext context) {
    DataManager.createFinal();
    return Provider.of<DataManager>(context, listen: false).checkadm()
        ? DialogsManager()
        : Container(
            padding: EdgeInsets.all(Sizer.largu * 5),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Pedido',
                        style: TextStyle(
                          fontFamily: 'Coiny',
                          fontSize: Sizer.largu * 4,
                          fontWeight: FontWeight.w300,
                          color: preto,
                          letterSpacing: 2,
                        )),
                    SizedBox(),
                  ],
                ),
                SizedBox(height: Sizer.altu * 2),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: cinza,
                      border: Border.all(color: branco, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  child: FinalList(),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: cinza,
                      border: Border.all(color: branco, width: 3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 5),
                      Text('Frete',
                          style: TextStyle(
                            fontSize: Sizer.largu * 3,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                          )),
                      Expanded(child: SizedBox(width: 5)),
                      Text('R\$ 10.00',
                          style: TextStyle(
                            fontSize: Sizer.largu * 3,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                          )),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: cinza,
                      border: Border.all(color: branco, width: 3),
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 5),
                      Text('Total: ',
                          style: TextStyle(
                            fontSize: Sizer.largu * 4,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          )),
                      Expanded(child: SizedBox(width: 5)),
                      Text(
                          'R\$ ' +
                              '${DataManager.calculateTotal().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: Sizer.largu * 4,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          )),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                SizedBox(height: Sizer.altu * 3),
                Text(
                  'Previsão de entrega: 20:34',
                  style: TextStyle(
                    fontFamily: 'Coiny',
                    fontSize: Sizer.largu * 4,
                    fontWeight: FontWeight.w300,
                    color: preto,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: Sizer.altu * 10),
                Container(
                  padding: EdgeInsets.all(Sizer.largu * 10),
                  child: RawMaterialButton(
                      padding: EdgeInsets.all(8),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: branco, width: 2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      fillColor: preto,
                      onPressed: () =>
                          Provider.of<DataManager>(context, listen: false)
                              .baterPapo(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/scooter.png'),
                          SizedBox(width: Sizer.largu * 5),
                          Text(
                            'Pode Trazer',
                            style: TextStyle(
                              fontFamily: 'Coiny',
                              fontSize: Sizer.largu * 5,
                              fontWeight: FontWeight.w400,
                              color: branco,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(width: Sizer.largu * 5),
                        ],
                      )),
                )
              ],
            ),
          );
  }
}
