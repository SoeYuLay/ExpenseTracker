import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  late Box box;
  bool isSignedIn = false;
  bool isBoxOpened = false;

  Future<void> initAuth() async{
    if(!isBoxOpened){
      box = await Hive.openBox("credentials");
      isSignedIn = box.get('isSignedIn',defaultValue: false);
      isBoxOpened = true;
      notifyListeners();
    }
  }

  Map<String, String> getUserData(){
    return {
      'name' : box.get('name'),
      'email': box.get('email')
    };
  }

  Future<void> signUp(String name, String email, String password) async {
    // Box box = await Hive.openBox("credentials");
    await box.put('name', name);
    await box.put('email', email);
    await box.put('password', password);
    await box.put('isSignedIn', false);
  }

  Future<bool> signIn(String email, String password) async {
    // Box box = await Hive.openBox("credentials");
    if (email == box.get('email') && password == box.get('password')) {
      await box.put('isSignedIn', true);
      isSignedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    // Box box = await Hive.openBox("credentials");
    await box.put('isSignedIn', false);
    isSignedIn = false;
    notifyListeners();
  }
  //
  // void printStoredData() {
  //   print("Name: ${box.get('name', defaultValue: 'No Name')}");
  //   print("Email: ${box.get('email', defaultValue: 'No Email')}");
  //   print("Password: ${box.get('password', defaultValue: 'No Password')}");
  //   print("Is Signed In: ${box.get('isSignedIn', defaultValue: false)}");
  // }
}
