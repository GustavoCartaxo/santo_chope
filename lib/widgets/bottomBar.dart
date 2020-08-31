import 'package:flutter/material.dart';
import 'package:santo_chope/sizer.dart';
import 'package:santo_chope/widgets/clipperPath.dart';
import 'package:santo_chope/colorPalette.dart';
import 'package:santo_chope/dataManager.dart';
import 'package:provider/provider.dart';
import 'package:santo_chope/widgets/productsList.dart';
import 'package:santo_chope/widgets/products2List.dart';
import 'package:santo_chope/screens/pagamentoScreen.dart';
import 'package:santo_chope/screens/profileScreen.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 1;
  final PageStorageBucket bucket = PageStorageBucket();
  final controller = PageController(initialPage: 1);
  final List<Widget> pages = [
    PagamentoScreen(),
    ProductsList(key: PageStorageKey('Page1')),
    Products2List(key: PageStorageKey('Page2')),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: PageStorage(
            child: PageView(
              controller: controller,
              children: <Widget>[
                PagamentoScreen(),
                ProductsList(key: PageStorageKey('Page1')),
                Products2List(key: PageStorageKey('Page2')),
                Profile(),
              ],
              onPageChanged: (pageIndex) {
                setState(() {
                  index = pageIndex;
                });
              },
            ),
            bucket: bucket),
      ),
      Consumer<DataManager>(builder: (context, quantidades, child) {
        return Positioned(
            top: DataManager.quantidades.reduce((i, j) => i + j) +
                            DataManager.quantidades2.reduce((i, j) => i + j) >
                        0 &&
                    index != 0
                ? Sizer.altu * 72
                : Sizer.altu * 90,
            left: Sizer.largu * 10,
            child: Container(
                color: cinza,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: Sizer.altu * 8, width: Sizer.largu * 50),
                    Text(
                      'Total: R\$' +
                          '${DataManager.calculateTotal().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: Sizer.largu * 4,
                        fontWeight: FontWeight.w300,
                        color: preto,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: Sizer.altu * 8, width: Sizer.largu * 10),
                  ],
                )));
      }),
      Positioned(
        top: Sizer.altu,
        child: ClipPath(
            clipper: BottomBarClipper(),
            child: Container(
                height: Sizer.altu * 88.2,
                width: Sizer.largu * 100,
                color: branco)),
      ),
      Positioned(
        left: Sizer.largu * 4,
        top: Sizer.altu * 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Consumer<DataManager>(builder: (context, quantidades, child) {
              return RawMaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    setState(() {
                      if (DataManager.quantidades.reduce((i, j) => i + j) +
                              DataManager.quantidades2.reduce((i, j) => i + j) >
                          0) {
                        index = 0;
                        controller.animateToPage(index,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.decelerate);
                      }
                    });
                  },
                  elevation: 10.0,
                  fillColor: index == 0
                      ? verde
                      : DataManager.quantidades.reduce((i, j) => i + j) +
                                  DataManager.quantidades2
                                      .reduce((i, j) => i + j) >
                              0
                          ? preto
                          : cinzaclaro,
                  shape: CircleBorder(
                    side: BorderSide(color: branco, width: 2),
                  ),
                  child: Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: -6,
                    children: <Widget>[
                      Icon(Icons.shopping_cart,
                          color: branco, size: Sizer.largu * 8),
                      Text(
                        'Pedir',
                        style: TextStyle(
                          fontFamily: 'Coiny',
                          fontSize: Sizer.largu * 4.5,
                          fontWeight: FontWeight.w400,
                          color: branco,
                        ),
                      ),
                    ],
                  ));
            }),
            SizedBox(width: Sizer.largu * 7),
            RawMaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  index = 1;
                  controller.animateToPage(index,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.decelerate);
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: Sizer.altu * 6.6,
                    width: Sizer.largu * 15,
                  ),
                  Image.asset('assets/geladeira.png',
                      color: index == 1 ? verde : preto),
                  Text(
                    'Tradicionais',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: Sizer.largu * 3,
                      fontWeight: FontWeight.w300,
                      color: index == 1 ? verde : preto,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Sizer.largu * 7),
            RawMaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  index = 2;
                  controller.animateToPage(index,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.decelerate);
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: Sizer.altu * 6.6,
                    width: Sizer.largu * 15,
                  ),
                  Icon(Icons.star, size: 52, color: index == 2 ? verde : preto),
                  Text(
                    'Artesanais',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: Sizer.largu * 3,
                      fontWeight: FontWeight.w300,
                      color: index == 2 ? verde : preto,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Sizer.largu * 6),
            RawMaterialButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  index = 3;
                  controller.animateToPage(index,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.decelerate);
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: Sizer.altu * 6.6,
                    width: Sizer.largu * 15,
                  ),
                  Icon(Icons.person,
                      size: 52, color: index == 3 ? verde : preto),
                  Text(
                    'Perfil',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: Sizer.largu * 3,
                      fontWeight: FontWeight.w300,
                      color: index == 3 ? verde : preto,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
