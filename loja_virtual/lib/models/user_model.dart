import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  //usuario atual

  bool _isLoading = false;

  bool get isLoading => _isLoading;


  void singUp() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 3));

    _isLoading = false;
    notifyListeners();
  }

  void singIn(){

  }

  void recoverPass(){

  }

  bool isLoggedIn(){

  }
}