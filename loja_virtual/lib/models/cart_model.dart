import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class CartModel extends Model {

  UserModel _user;
  List<CartProduct> _products = [];
  List<CartProduct> get products => _products;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _couponCode;
  String get couponCode => _couponCode;
  set couponCode(String couponCode) {_couponCode = couponCode;}

  int _discountPercentage = 0;
  int get discountPercentage => _discountPercentage;
  set discountPercentage(int discountPercentage) {_discountPercentage = discountPercentage;}




  CartModel(this._user){
    if(_user.isLoggedIn()){
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);


  void addCartItem(CartProduct cartProduct){
    _products.add(cartProduct);
    
    FirebaseFirestore.instance.collection("users").doc(_user.firebaseUser.uid)
        .collection("cart").add(cartProduct.toMap()).then((doc){
          cartProduct.cid = doc.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    FirebaseFirestore.instance.collection("users").doc(_user.firebaseUser.uid)
        .collection("cart").doc(cartProduct.cid).delete();
    
    _products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    FirebaseFirestore.instance.collection("users").doc(_user.firebaseUser.uid).collection("cart")
        .doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    FirebaseFirestore.instance.collection("users").doc(_user.firebaseUser.uid).collection("cart")
        .doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(_user.firebaseUser.uid).collection("cart")
        .get();

    _products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getDiscount(){
    return getProductPrice() * (discountPercentage / 100);
  }

  double getShipPrice(){
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }
}
