import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/domain/provider/getuserdata_provider.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GetUserDataProvider getUserDataProvider = GetUserDataProvider();
  //sing user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    //catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //create new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //проверка совпадения паролей
  bool passwordConfirmed(String password, String confirmPassword) {
    if (password.trim() == confirmPassword.trim()) {
      return true;
    } else {
      return false;
    }
  }

//выход
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await getUserDataProvider.updateStatus(false);
  }
}
