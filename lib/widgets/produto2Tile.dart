import 'package:flutter/material.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:santo_chope/sizer.dart';
import 'package:provider/provider.dart';
import 'package:santo_chope/dataManager.dart';

class Product2Tile extends StatefulWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productID;
  //final image productImage;

  Product2Tile(this.productName, this.productDescription, this.productPrice,
      this.productID);

  @override
  _Product2TileState createState() => _Product2TileState();
}

class _Product2TileState extends State<Product2Tile>
    with AutomaticKeepAliveClientMixin {
  bool visiblePlus;
  bool visibleMinus;
  int numberOfProducts = 0;

  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    visiblePlus = DataManager.quantidades2[widget.productID] > 0 ? true : false;
    visibleMinus =
        DataManager.quantidades2[widget.productID] > 1 ? true : false;
    return Container(
      margin: EdgeInsets.all(Sizer.largu * 1.5),
      child: RaisedButton(
        elevation: 4.0,
        color: DataManager.quantidades2[widget.productID] > 0 ? verde : preto,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: branco, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () {
          setState(() {
            if (DataManager.quantidades2[widget.productID] > 0) {
              Provider.of<DataManager>(context, listen: false)
                  .zerarQuantidade2(widget.productID);
            } else {
              Provider.of<DataManager>(context, listen: false)
                  .changeQuantidade2(widget.productID, true);
            }
          });
          //player.play('level-up.mp3');
        },
        child: Row(children: <Widget>[
          SizedBox(
              width: Sizer.largu * 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: Sizer.largu * 24,
                    height: Sizer.altu * 12,
                    child: Stack(
                      children: [
                        Positioned(
                          top: Sizer.altu,
                          left: -Sizer.largu * 4.5,
                          child: Opacity(
                            opacity: visibleMinus ? 1.0 : 0,
                            child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    if (DataManager
                                            .quantidades2[widget.productID] >
                                        0) {
                                      Provider.of<DataManager>(context,
                                              listen: false)
                                          .changeQuantidade2(
                                              widget.productID, false);
                                    } else {
                                      Provider.of<DataManager>(context,
                                              listen: false)
                                          .changeQuantidade2(
                                              widget.productID, true);
                                    }
                                  });
                                },
                                shape: CircleBorder(),
                                fillColor: Colors.white,
                                child: Image.asset(
                                  'assets/minus.png',
                                  height: Sizer.altu * 3.2,
                                )),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: DataManager.quantidades2[widget.productID] > 9
                              ? Sizer.largu * 9.5
                              : Sizer.largu * 11.5,
                          child: Text(
                            DataManager.quantidades2[widget.productID]
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'Coiny',
                              fontSize: Sizer.largu * 8,
                              fontWeight: FontWeight.w600,
                              color: preto,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Sizer.altu,
                          left: Sizer.largu * 11.5,
                          child: Opacity(
                            opacity: visiblePlus ? 1.0 : 0,
                            child: RawMaterialButton(
                                padding: EdgeInsets.all(8),
                                onPressed: () {
                                  setState(() {
                                    Provider.of<DataManager>(context,
                                            listen: false)
                                        .changeQuantidade2(
                                            widget.productID, true);
                                  });
                                },
                                shape: CircleBorder(),
                                fillColor: branco,
                                child: Image.asset(
                                  'assets/plus.png',
                                  height: Sizer.altu * 3.2,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              height: Sizer.altu * 12,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      widget.productName,
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: Sizer.largu * 5,
                        fontWeight: FontWeight.w500,
                        color: branco,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      widget.productDescription,
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: Sizer.largu * 3,
                        fontWeight: FontWeight.w200,
                        color: cinza,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: Sizer.altu * 1),
                    Text(
                      'R\$ ' + '${widget.productPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: Sizer.largu * 4,
                        fontWeight: FontWeight.w300,
                        color: branco,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: Sizer.altu * 1),
                  ]),
            ),
          ),
          Container(
            margin: EdgeInsets.all(Sizer.largu * 1),
            child: FlatButton(
              padding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  builder: (context) => Container(
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
                          Image.asset(
                            'assets/apasotera.jpg',
                            height: Sizer.altu * 42,
                            width: Sizer.largu * 65,
                          ),
                          Text(
                              'Description of product, lorem ipsum deainfea mnifae')
                        ],
                      ),
                    ),
                  ),
                );
              },
              color: branco,
              child: Container(
                height: Sizer.largu * 15,
                width: Sizer.largu * 15,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/apasotera.jpg',
                    height: Sizer.altu * 10,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
