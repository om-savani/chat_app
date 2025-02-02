import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class FirebaseServices {
  FirebaseServices._();
  static FirebaseServices firebaseServices = FirebaseServices._();
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  // Register with email and password
  Future<String> register(String email, String password) async {
    String msg;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      msg = "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          msg = 'this service not available';
        case 'week-password':
          msg = "Your password is too week";
        default:
          msg = e.code;
      }
    }
    return msg;
  }

  // Login with email and password
  Future<String?> login(String email, String password) async {
    String msg;
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      msg = "Success";
      return msg;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = 'No user found with this email.';
        Get.snackbar('Error', msg);
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password provided for this user.';
        Get.snackbar('Error', msg);
      } else if (e.code == 'invalid-email') {
        msg = 'Invalid email format.';
        Get.snackbar('Error', msg);
      } else {
        msg = e.toString();
        Get.snackbar('Error', 'Login failed. Please try again.');
      }
      return null;
    } catch (e) {
      Logger().e('Unexpected error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      return null;
    }
  }

// Add User With Google
  Future<String?> loginWithGoogle() async {
    String msg;
    try {
      GoogleSignInAccount? user = await GoogleSignIn().signIn();
      if (user == null) {
        Logger().e('GoogleSignIn canceled by user');
        Get.snackbar('Error', 'Google sign-in canceled.');
        return null;
      }
      GoogleSignInAuthentication googleAuth = await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential credentialUser =
          await auth.signInWithCredential(credential);
      msg = "Success";
      return msg;
    } catch (e) {
      Logger().e('Google login error: $e');
      Get.snackbar('Error', 'Google login failed: $e');
      return null;
    }
  }

// Login with anonymous
  Future<User?> loginAnonymous() async {
    try {
      UserCredential credential = await auth.signInAnonymously();
      return credential.user;
    } catch (e) {
      Logger().e('Anonymous login error: $e');
      Get.snackbar('Error', 'Anonymous login failed: $e');
      return null;
    }
  }

  User? get currentUser => auth.currentUser;

  void logout() async {
    await auth.signOut();
    googleSignIn.signOut();
  }
}
