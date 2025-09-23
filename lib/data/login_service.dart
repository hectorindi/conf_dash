import 'package:admin/models/LoginObject.dart';
import 'package:admin/models/member_object.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin/data/database_services.dart';
//import 'dart:developer';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

var errorText = "";

class AuthService {

  // var
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<LoginObject> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return LoginObject(name: userCredential.user?.displayName ?? '', successful: true, uid: userCredential.user?.uid);
    } catch (e) {
      print('Error signing in: $e');
      return LoginObject(name: '', successful: true, uid: null, error: e.toString());
    }
  }

  bool checkRequiredFields(MemberObject member, String email, String password) {
    if (member.name.isEmpty || member.address == null || member.phoneNumber == null || email.isEmpty || password.isEmpty) {
      errorText = "Please fill all the required fields.";
      return false;
    }
    if (password.length < 6) {
      errorText = "Password must be at least 6 characters long.";
      return false;
    }
    return true;
  }

  Future<LoginObject> signUp(MemberObject member , String email, String password) async {
    final bool isValid = checkRequiredFields(member, email, password);
    if (!isValid) {
      return LoginObject(name: email, successful: false, uid: null, error: errorText);
    }
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((userCredential) async {
        await memberService.value.addMemberDetailsToDatabase(userCredential, member);
        return userCredential;
      });
      return LoginObject(name: userCredential.user?.displayName ?? '', successful: true, uid: userCredential.user?.uid);
    } catch (e) {
      ////log('Error signing up: $e');
      var errorMessage = e.toString().split(  '] ').last; // Extract message after '] '
      return LoginObject(name: email, successful: false, uid: null, error: errorMessage);
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      ////log("Sign Out Successful");
      return true;
    } catch (e) {
      ////log('Error signing out: $e');
      return false;
    }
    
  }

  Future<void> updateUserName(String name) async {
    User? user = currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
    }
  }

  Future<void> deleteUser() async {
    User? user = currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}