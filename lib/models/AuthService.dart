import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future deleteUser(String email, String password) async {
    try {
      User user = await _auth.currentUser;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);
      await result.user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
