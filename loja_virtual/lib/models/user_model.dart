import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  //usuario atual

  FirebaseAuth _auth = FirebaseAuth.instance;
  User _firebaseUser;

  Map<String, dynamic> _userData = Map();
  Map<String, dynamic> get userData => _userData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this._userData = userData;
    await FirebaseFirestore.instance.collection("users").doc(_firebaseUser.uid).set(userData);
  }

  void signOut() async {
    await _auth.signOut();

    _userData = Map();
    _firebaseUser = null;

    notifyListeners();
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}){

    _isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async {
      _firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();
      _isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      _isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    _isLoading = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass
    ).then((user) async {
      _firebaseUser = user as User;

      await _loadCurrentUser();

      onSuccess();
      _isLoading = false;
      notifyListeners();

    }).catchError((e){
      onFail();
      _isLoading = false;
      notifyListeners();
    });
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    return _firebaseUser != null && _firebaseUser.displayName != "";
  }

  Future<Null> _loadCurrentUser() async {
    if(_firebaseUser == null)
      _firebaseUser = await _auth.currentUser;
    if(_firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
            await FirebaseFirestore.instance.collection("users").doc(_firebaseUser.uid).get();
        _userData = docUser.data();
      }
    }
    notifyListeners();
  }
}