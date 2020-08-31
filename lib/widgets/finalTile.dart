import 'package:flutter/material.dart';
import 'package:santo_chope/sizer.dart';

class FinalTile extends StatelessWidget {
  final int amount;
  final String produto;
  final double price;

  FinalTile(this.amount, this.produto, this.price);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 5),
        Text(amount.toString(),
            style: TextStyle(
              fontSize: Sizer.largu * 3,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
            )),
        SizedBox(width: 5),
        Text(produto,
            style: TextStyle(
              fontSize: Sizer.largu * 3,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
            )),
        Expanded(child: SizedBox(width: 5)),
        Text('R\$ ' '${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Sizer.largu * 3,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
            )),
        SizedBox(width: 5),
      ],
    );
  }
}
