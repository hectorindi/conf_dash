import 'dart:developer';

import 'package:admin/models/member_object.dart';
import 'package:admin/data/login_service.dart';
import 'package:admin/screens/forms/components/add_member_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

ValueNotifier<MemberService> memberService = ValueNotifier(MemberService());

var errorText = "";

class MemberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MemberObject? _member;
  MemberObject get currentMember => _member!;

  Future<MemberObject?> getMemberDetails() async {
    MemberObject? member;
    try {
      String uid = authService.value.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
      if (documentSnapshot.exists) {
         dynamic data = documentSnapshot.data();
         data = documentSnapshot.data() as Map<String, dynamic>;
         var dateObj = (data['createdAt']).toString();
         DateTime dt = (data['createdAt'] as Timestamp).toDate();
         data['createdAt'] = '';
         var encodedString = jsonEncode(data);
         Map<String, dynamic> valueMap = json.decode(encodedString);
         MemberObject user = MemberObject.fromJson(valueMap);
         member = MemberObject(
          uid: user.uid,
          name: user.name,
          email: user.email,
          address: user.address,
          createdAt: dateObj,
          accessToken: user.accessToken,
          isAdmin: user.isAdmin,
          phoneNumber: user.phoneNumber,
        );
        member.memberSince = dt;
        _member = member;
      }
    } catch (e) {
      log('Error signing in: $e');
    }
    return member;
  }

  Future<bool?> addMemberDetailsToDatabase(UserCredential userCredential, MemberObject member) async {
    String uid = userCredential.user!.uid;
    var user = userCredential.user;
    try {
      CollectionReference ref = _firestore.collection('users');
      await ref.doc(uid).set({
        'email': user?.email,
        'roles': member.isAdmin ? 'admin' : 'user',
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'name': member.name,
        'address': member.address,
        'speciality': member.specialization,
        'phoneNumber': member.phoneNumber,
      });
      return true;
    } catch (e) {
      //log('Error signing in: $e');
      return false;
    }
  }

  Future<bool?> addMemberCategoryToDatabase(String category,String status) async {
    try {
      CollectionReference ref = _firestore.collection('aios_0925');
      log("Adding Member Category: $category with status: $status by user: $category");
      await ref.doc("member_category").collection("mem_ct").add({
        'category': category,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      log('Error adding member category: $e');
      return false;
    }
  }

  Future<List <Map<String, dynamic>>> getMemberCategoryFromDatabase() async {
    try {
      CollectionReference ref = _firestore.collection('aios_0925').doc("member_category").collection("mem_ct");
      log("Fetching Member Category");
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          log("Member Category: ${data['category']}, Status: ${data['status']}");
        });
        return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      }
    } catch (e) {
      log('Error fetching member category: $e');
      return [{errorText: e.toString()}];
    }
    return [{errorText: "Something went wrong"}];
  }
}