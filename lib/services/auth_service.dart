// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String name;
  final String email;
  final String uid;
  AuthUser({required this.name, required this.email, required this.uid});
}

class AuthService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  AuthUser? _user;
  AuthUser? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthService() {
    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        _user = null;
      } else {
        _user = AuthUser(
          name: firebaseUser.displayName ?? firebaseUser.email!.split('@').first,
          email: firebaseUser.email!,
          uid: firebaseUser.uid,
        );
      }
      notifyListeners();
    });
  }

  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return "Please fill in all fields.";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found': return "No account found with this email.";
        case 'wrong-password': return "Incorrect password.";
        case 'invalid-email':  return "Please enter a valid email address.";
        case 'too-many-requests': return "Too many attempts. Try again later.";
        case 'operation-not-allowed': return "Email/password sign-in is not enabled in Firebase Console.";
        case 'network-request-failed': return "Network error. Check your internet connection.";
        case 'invalid-credential': return "Invalid email or password.";
        case 'INVALID_LOGIN_CREDENTIALS': return "Invalid email or password.";
        default: return "Login failed (${e.code}): ${e.message}";
      }
    }
  }

  Future<String?> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) return "Please fill in all fields.";
    if (!email.contains('@')) return "Please enter a valid email address.";
    if (password.length < 6) return "Password must be at least 6 characters.";
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await result.user?.updateDisplayName(name);
      await result.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use': return "An account already exists with this email.";
        case 'weak-password': return "Password is too weak.";
        case 'operation-not-allowed': return "Email/password sign-in is not enabled. Enable it in the Firebase Console under Authentication > Sign-in method.";
        case 'network-request-failed': return "Network error. Check your internet connection.";
        case 'invalid-credential': return "Invalid credentials. Please check your email and password.";
        default: return "Sign up failed (${e.code}): ${e.message}";
      }
    }
  }

  Future<void> logout() async => await _auth.signOut();

  Future<String?> updateDisplayName(String name) async {
    if (name.isEmpty) return "Name cannot be empty.";
    try {
      await _auth.currentUser?.updateDisplayName(name);
      if (_user != null) {
        _user = AuthUser(name: name, email: _user!.email, uid: _user!.uid);
        notifyListeners();
      }
      return null;
    } catch (_) {
      return "Failed to update name.";
    }
  }

  Future<String?> updatePassword(String currentPassword, String newPassword) async {
    if (newPassword.length < 6) return "Password must be at least 6 characters.";
    try {
      final user = _auth.currentUser!;
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password': return "Current password is incorrect.";
        case 'too-many-requests': return "Too many attempts. Try again later.";
        default: return "Failed to update password (${e.code}).";
      }
    }
  }

  Future<String?> resetPassword(String email) async {
    if (email.isEmpty) return "Please enter your email.";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found': return "No account found with this email.";
        case 'invalid-email': return "Please enter a valid email address.";
        default: return "Failed to send reset email (${e.code}).";
      }
    }
  }
}

