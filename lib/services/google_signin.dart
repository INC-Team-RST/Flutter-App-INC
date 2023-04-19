import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/api/admin_api.dart';
import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/models/admin_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

const storage = FlutterSecureStorage();

class SignIn {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithGoogleUser() async {
    //bool isNewUser = true; //assuming its a new user
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      log(userCredential.user!.uid.toString());

      bool check = await checkUser(uid: userCredential.user!.uid);

      print(check);

      if (check) {
        await loginUser(
            uid: userCredential.user!.uid, token: googleAuth.accessToken!);
        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else {
        await addUser(
            accessToken: googleAuth.accessToken!,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName!,
            uid: userCredential.user!.uid,
            phone: "",
            photoURL: userCredential.user!.photoURL!);
        Fluttertoast.showToast(
            msg: "Login Successful, user added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
      log(googleAuth.accessToken.toString());
      await storage.write(
          key: 'user_access_token', value: googleAuth.accessToken!);
      await storage.write(key: 'user_type', value: 'user');
      return googleAuth.accessToken!;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      log(e.toString());
      return "";
    }

    // isNewUser = userCredential.additionalUserInfo!.isNewUser;

    // if (isNewUser) {
    //   storeUserDetails();
    // }

    // await FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(_auth.currentUser!.uid)
    //     .get()
    //     .then((user) {
    //   LocalUser.uid = user['uid'];
    //   LocalUser.email = user['email'];
    //   LocalUser.displayName = user['displayName'];
    //   LocalUser.photoURL = user['photoURL'];
    //   LocalUser.isCA = user['isCA'];
    //   LocalUser.caId = user['caId'] ?? '';
    // });
    //log(isNewUser.toString());
    //return isNewUser;
  }

  Future<void> storeUserDetails() async {
    final CollectionReference usercollection =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String email = auth.currentUser!.email.toString();
    User? user = auth.currentUser;

    await usercollection.doc(uid).set({
      "displayName": user!.displayName,
      "phoneNumber": user.phoneNumber,
      "email": email,
      "photoURL": user.photoURL,
      "uid": user.uid,
      "lastMessageTime": Timestamp.now(),
      "isCA": false,
      "caId": null,
    }, SetOptions(merge: true));

    // TODO: Add Admin User to Database
    // final CollectionReference chatCollection = FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(uid)
    //     .collection('Chats');
    // chatCollection.add(
    //   {
    //     "displayName": AdminInfo.displayName,
    //     "phoneNumber": AdminInfo.phoneNumber,
    //     "email": AdminInfo.email,
    //     "photoURL": AdminInfo.photoURL,
    //     "uid": AdminInfo.uid,
    //     "createdAt": Timestamp.now(),
    //     "Message":
    //         "Hi there I am your CA, Welcome to this app! Feel free to ask any doubts here!",
    //   },
    // );
    return;
  }

  Future<bool> signInWithGoogleAdmin() async {
    //late final bool isNewUser;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      //isNewUser = userCredential.additionalUserInfo!.isNewUser;
      log(userCredential.user!.uid.toString());
      log(googleAuth.accessToken.toString());
      await storage.write(
          key: 'admin_access_token', value: googleAuth.accessToken!);
      await storage.write(key: 'user_type', value: 'admin');

      bool check = await checkAdmin(userCredential.user!.uid);

      if (check) {
        // if true then admin exists so just login
        loginAdmin(
            uid: userCredential.user!.uid, token: googleAuth.accessToken!);
        return true;
      } else {
        addAdmin(
          email: userCredential.user!.email!,
          displayName: userCredential.user!.displayName!,
          uid: userCredential.user!.uid,
          phone: "",
          photoURL: userCredential.user!.photoURL!,
          accessToken: googleAuth.accessToken!,
        );

        return false;
      }

      // if (isNewUser) {
      //   storeAdminDetails();
      // }

      log("Admin Test");

      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(_auth.currentUser!.uid)
      //     .get()
      //     .then((user) {
      //   AdminInfo.uid = user['uid'];
      //   AdminInfo.email = user['email'];
      //   AdminInfo.displayName = user['displayName'];
      //   AdminInfo.photoURL = user['photoURL'];
      //   AdminInfo.isCA = user['isCA'];
      // });

      log("Hello");
      log(AdminInfo.uid!);
      // return;
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> storeAdminDetails() async {
    final CollectionReference usercollection =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String email = auth.currentUser!.email.toString();
    User? user = auth.currentUser;

    await usercollection.doc(uid).set({
      "displayName": user!.displayName,
      "phoneNumber": user.phoneNumber,
      "email": email,
      "photoURL": user.photoURL,
      "uid": user.uid,
      "lastMessageTime": Timestamp.now(),
      "isCA": true,
    }, SetOptions(merge: true));
  }
}
