import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInServices {
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  static Future signInWitchGoole() async {
    try {
      final account = await _googleSignIn.signIn();

      print(account);
      return account;
    } catch (e) {
      print('error signin google');
      print(e);
    }
  }
}
