import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    print(e.toString());
    return null;
  }
}

Future<dynamic> getAuth() async {
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('User is currently signed out!');
    await signInWithGoogle();
    user = FirebaseAuth.instance.currentUser;
  } else {
    print('User is signed in!');
  }
  return user;
}
