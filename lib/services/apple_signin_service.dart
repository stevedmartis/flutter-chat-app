import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInService {
  static void signIn() async {
    await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
  }
}
