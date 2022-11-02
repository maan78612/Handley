import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/model_classes/disableDates.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/utilities/show_message.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<String?> createUserWithEmailPassword(
      String email, String password) async {
    try {
      var user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      return user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print("I am Error \n\n\n $e");
      }
      return "0";
    }
  }

  static Future<User?> getCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  static Future<User?> signInWithEmailPassword(
      String email, String password) async {
    if (kDebugMode) {
      print("i am sign in will provide UserId");
    }

    var user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (kDebugMode) {
      print("===================user id is ${user?.uid}============");
    }
    return user;
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
    Provider.of<AppProvider>(Get.context!, listen: false).onDispose();
    Provider.of<AuthProvider>(Get.context!, listen: false).onDispose();
    Provider.of<ChatProvider>(Get.context!, listen: false).onDispose();
  }

  static Future<void> sendResetPassEmail(String email) async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      if (kDebugMode) {
        print("success");
      }
      ShowMessage.toast(
        "Password reset Link sent Successfully,\n Please check your mail box",
      );
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    }).catchError((e) {
      String error = e.toString();
      if (kDebugMode) {
        print(error);
      }

      if (error.contains('[firebase_auth/user-not-found]')) {
        ShowMessage.toast(
          'Email not registered',
        );
      } else {
        if (kDebugMode) {
          print(e.toString());
        }
        ShowMessage.toast(
          e.toString(),
        );
      }
    });
  }

  static Stream<List<UserData>> getAllUsers() {
    var ref = FBCollections.users.snapshots().asBroadcastStream();
    var x = ref.map(
        (event) => event.docs.map((e) => UserData.fromJson(e.data())).toList());
    return x;
  }

  static Future<List<Professions>> getAllProfessions() async {
    var ref = await FBCollections.professions.get();

    List<Professions> allProfessions =
        ref.docs.map((doc) => Professions.fromJson(doc.data())).toList();

    return allProfessions;
  }

  /*  ===================Disable and enable Professional Date ===================*/
  static Future<List<DisableDates>> getDisableDatesService(
      UserData user) async {
    final QuerySnapshot? doc1 = await FBCollections.disableDates
        .where("proId", isEqualTo: user.email)
        .get();
    List<DisableDates> disableDates = [];
    doc1?.docs.forEach((disableDate) {
      disableDates.add(DisableDates.fromJson(disableDate));
      print(disableDate.id);
    });

    print("length of  DISABLE dates for ${user.email} ${disableDates.length}");
    return disableDates;
  }

  static updateDisableDatesForProfessional(DisableDates disableDate) async {
    await FBCollections.disableDates
        .doc(disableDate.id)
        .set(disableDate.toJson());
  }

// static temp() async {
//   QuerySnapshot ref = await FBCollections.bookings.get();
//
//   print(jsonEncode(ref.docs.first.data()));
// }
}
