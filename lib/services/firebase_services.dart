import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class FirebaseServices {
  FirebaseServices._();
  static FirebaseServices firebaseServices = FirebaseServices._();
  FirebaseAuth auth = FirebaseAuth.instance;

  // Register with email and password
  Future<User?> register(String email, String password) async {
    User? user;
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Logger().e('Error: Email is already in use');
        Get.snackbar('Error', 'The email address is already in use.');
      } else if (e.code == 'invalid-email') {
        Logger().e('Error: Invalid email format');
        Get.snackbar('Error', 'The email address is not valid.');
      } else if (e.code == 'weak-password') {
        Logger().e('Error: Weak password');
        Get.snackbar('Error', 'The password is too weak.');
      } else {
        Logger().e('FirebaseAuthException: $e');
        Get.snackbar('Error', 'Failed to register. Please try again.');
      }
    } catch (e) {
      Logger().e('Unexpected error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
    return user;
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Logger().e('Error: User not found');
        Get.snackbar('Error', 'No user found with this email.');
      } else if (e.code == 'wrong-password') {
        Logger().e('Error: Wrong password');
        Get.snackbar('Error', 'Incorrect password. Please try again.');
      } else if (e.code == 'invalid-email') {
        Logger().e('Error: Invalid email');
        Get.snackbar('Error', 'Invalid email format.');
      } else {
        Logger().e('FirebaseAuthException: $e');
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
  Future<User?> loginWithGoogle() async {
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
      return credentialUser.user;
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
}
