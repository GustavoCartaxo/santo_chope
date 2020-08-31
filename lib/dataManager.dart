import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:santo_chope/widgets/finalTile.dart';
import 'package:santo_chope/widgets/produtoTile.dart';
import 'package:santo_chope/widgets/produto2Tile.dart';

class DataManager extends ChangeNotifier {
  static List<FinalTile> finals = [];
  static List<ProductTile> products = [];
  static List<Product2Tile> products2 = [];
  static List<int> quantidades = [0];
  static List<int> quantidades2 = [0];
  static int produtoID = 0;
  static int produto2ID = 0;
  static bool register = false;
  static bool loggedIn = false;
  static bool saving = false;
  static bool atualizar = false;
  static bool batepapo = false;
  static String papoID;
  bool peuOn = false;

  void admOn() {
    peuOn = true;
  }

  bool checkadm() {
    if (peuOn) {
      return true;
    } else
      return false;
  }

  static void createFinal() {
    finals.removeRange(0, finals.length);
    for (var i = 0; i < products.length; i++) {
      if (quantidades[i] > 0) {
        finals.add(new FinalTile(quantidades[i], products[i].productName,
            products[i].productPrice * quantidades[i]));
      }
    }
    for (var i = 0; i < products2.length; i++) {
      if (quantidades2[i] > 0) {
        finals.add(new FinalTile(quantidades2[i], products2[i].productName,
            products2[i].productPrice * quantidades2[i]));
      }
    }
  }

  static double calculateTotal() {
    double soma = 0;
    for (var i = 0; i < products.length; i++) {
      soma += products[i].productPrice * quantidades[i];
    }
    for (var i = 0; i < products2.length; i++) {
      soma += products2[i].productPrice * quantidades2[i];
    }
    return soma;
  }

  void createProductTile(String nomeProduto, String descricaoProduto,
      double precoProduto, int estoque, String detalhe, String imageURL) {
    products.add(new ProductTile(nomeProduto, descricaoProduto, detalhe,
        precoProduto, estoque, produtoID, imageURL));
    quantidades.add(0);
    produtoID++;
  }

  void addProduct2(
      String nomeProduto, String descricaoProduto, double precoProduto) {
    products2.add(new Product2Tile(
      nomeProduto,
      descricaoProduto,
      precoProduto,
      produto2ID,
    ));
    quantidades2.add(0);
    produto2ID++;
  }

  void changeLoginScreen() {
    register = !register;
    notifyListeners();
  }

  void login() {
    loggedIn = !loggedIn;
    notifyListeners();
  }

  void baterPapo() {
    batepapo = !batepapo;
    notifyListeners();
  }

  void atualizate() {
    atualizar = !atualizar;
    notifyListeners();
  }

  void isSaving() {
    saving = !saving;
    notifyListeners();
  }

  void changeQuantidade(int index, String type) {
    if (type == 'plus')
      quantidades[index]++;
    else
      quantidades[index]--;
    notifyListeners();
  }

  void zerarQuantidade(int index) {
    quantidades[index] = 0;
    notifyListeners();
  }

  void changeQuantidade2(int index, bool plus) {
    if (plus)
      quantidades2[index]++;
    else
      quantidades2[index]--;
    notifyListeners();
  }

  void zerarQuantidade2(int index) {
    quantidades2[index] = 0;
    notifyListeners();
  }
}
