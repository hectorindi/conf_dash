//import 'dart:developer';

import 'package:admin/models/member_object.dart';
import 'package:admin/data/login_service.dart';
import 'package:admin/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

ValueNotifier<DatabaseServices> memberService = ValueNotifier(DatabaseServices());

var errorText = "";

class DatabaseServices {
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
      //log('Error signing in: $e');
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
      ////log('Error signing in: $e');
      return false;
    }
  }

  Future<bool?> getLasteMemeberRegID() async {
    try {
      CollectionReference ref = _firestore.collection(AppConstants.memberRegistrationLatestID);


      return true;
    } catch (e) {
      //log('Error adding member category: $e');
      return false;
    }
  }

  Future<bool?> addMemberCategoryToDatabase(String category,String status) async {
    try {
      CollectionReference ref = _firestore.collection(AppConstants.eventCollectionName);
      //log("Adding Member Category: $category with status: $status by user: $category");
      await ref.doc(AppConstants.memberCategoryDocName).collection(AppConstants.memberCategoryColName).add({
        'category': category,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      //log('Error adding member category: $e');
      return false;
    }
  }

  Future<bool?> addDelegateTypeToDatabase(String type,String status,double rate, String uid) async {
    try {
      CollectionReference ref = _firestore.collection(AppConstants.eventCollectionName);
      DocumentReference userRef = await ref.doc(AppConstants.memberCategoryDocName).collection(AppConstants.memberCategoryColName).doc(uid);
      //log("Adding delegate type : $type with status: $status by user: $type");
      await ref.doc(AppConstants.memberRegistedDocName).collection(AppConstants.memberRegisteredColName).add({
        'address': type,
        'category': userRef,
        'status': status,
        'rate': rate,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      //log('Error adding member category: $e');
      return false;
    }
  }

  Future<List <Map<String, dynamic>>> getMemberCategoryFromDatabase() async {
    try {
      CollectionReference ref = _firestore.collection(AppConstants.eventCollectionName).doc(AppConstants.memberCategoryDocName).collection("mem_ct");
      //log("Fetching Member Category");
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> finalData = [];
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['uid'] = doc.id;
          finalData.add(data);
          //log("Member Category: ${data['category']}, Status: ${data['status']}");
        });
        return finalData;
        //return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      }
    } catch (e) {
      //log('Error fetching member category: $e');
      return [{errorText: e.toString()}];
    }
    return [{errorText: "Something went wrong"}];
  }

  Future<List <Map<String, dynamic>>> getSpecializationFromDatabase() async {
    try {
      CollectionReference ref = _firestore.collection(AppConstants.eventCollectionName).doc(AppConstants.courseDocName).collection(AppConstants.courseColName);
      //log("Fetching Member Category");
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> finalData = [];
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['uid'] = doc.id;
          finalData.add(data);
          //log("Member Category: ${data['category']}, Status: ${data['status']}");
        });
        return finalData;
        //return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      }
    } catch (e) {
      //log('Error fetching member category: $e');
      return [{errorText: e.toString()}];
    }
    return [{errorText: "Something went wrong"}];
  }

  Future<List <Map<String, dynamic>>> getRegisteredMemebersFromDatabase() async {
    try {
      CollectionReference ref = _firestore.collection(AppConstants.eventCollectionName).doc(AppConstants.memberRegistedDocName).collection(AppConstants.memberRegisteredColName);
      List<Map<String, dynamic>> memberCategory = await getMemberCategoryFromDatabase();
      List<Map<String, dynamic>> specialization = await getSpecializationFromDatabase();
      //log("Fetching Member Category");
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> finalData = [];
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['uid'] = doc.id;
          memberCategory.forEach((action){
            if (action['uid'] == data['memberType'].id) {
              data['memberCategory'] = action['category'];
            }
          });
          specialization.forEach((action){
            if (action['uid'] == data['courses'].id) {
              data['specialization'] = action;
            }
          });
          finalData.add(data);
          //log("Member Category: ${data['category']}, Status: ${data['status']}");
        });
        return finalData;
        //return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      }
    } catch (e) {
      //log('Error fetching member category: $e');
      return [{errorText: e.toString()}];
    }
    return [{errorText: "Something went wrong"}];
  }

  Future<List<Map<String, dynamic>>> getMemberDelegateTypeFromDatabase() async {
    try {
      CollectionReference ref = _firestore.collection('aios_0925').doc("delegate_category").collection("ct_type");

      //log("Fetching Member Category");
      QuerySnapshot querySnapshot = await ref.get();
      if (querySnapshot.docs.isNotEmpty) {
        // Convert the docs to list of Map
        List<Map<String, dynamic>> memberCategory = await getMemberCategoryFromDatabase();
        List<Map<String, dynamic>> finalList = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        
        // Wait for all async operations to complete
        await Future.wait(
          finalList.map((action) async {
            DocumentReference dr = action["category"] as DocumentReference;
            QuerySnapshot dataSnapshot = await dr.collection(dr.id).get();
            // You can process dataSnapshot here
            // You might want to add the results back to your action map
            action['memberCategory'] = memberCategory;
            //log("data is $action.toString()");
          })
        );

        return finalList;
      } else {
        return [{"error": "Something went wrong"}];    
      }
    } catch (e) {
      //log('Error fetching member delegate type: $e');
      return [{errorText: e.toString()}];
    }
  }
}