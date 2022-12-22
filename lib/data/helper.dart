import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/pages/changemailpage.dart';
import 'package:workhunter/pages/createanaccountpage.dart';
import 'package:workhunter/pages/menudashboard.dart';
import 'package:workhunter/pages/profilepage.dart';
import 'package:workhunter/pages/walkinpage.dart';

class Service {
  final auth = FirebaseAuth.instance;
  // final FireServer server = FireServer();
  String verificationId = "";
  bool otpsent = false;
  Future<bool> createUser(email, password, context) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((_) {});
      return true;
    } catch (e) {
      error(context, e);
      return false;
    }
  }

  Future<bool> changemail(newmail, currentpassword, context) async {
    try {
      String? email = auth.currentUser!.email;
      await auth
          .signInWithEmailAndPassword(
              email: email.toString(), password: currentpassword)
          .then((userCredential) {
        print(0000000000000000000000);
        auth.currentUser!
            .verifyBeforeUpdateEmail(newmail)
            .then((value) => print(111111111111111));
        //new note after review->//
        //<-new note after review//
        auth.currentUser!.updateEmail(newmail).then((value) async {
          print("it will return in next step");
          // await server.updatemailtoprofile(newmail);
          auth.signOut().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => WalkInPage()));
          });

          return true;
        });
        print("its working change email function in helper dart file");
        // userCredential.user!.updateEmail('newyou@domain.com');
        return true;
      });
      return false;
    } catch (e) {
      error(context, e);
      return false;
    }
  }

  Future<bool> forgotpassword(email, context) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        await auth.sendPasswordResetEmail(email: email).then((_) {
          return true;
        });
        return false;
      } else {
        error(context, "No user found!.Try Creating an account");
        return false;
      }
    } catch (e) {
      error(context, e);
      return false;
    }
  }

  loginUser(email, password, context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => ProfilePage()));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MenuDashboardPage()));
      //print("Successfully logged in");
    } catch (e) {
      error(context, e);
    }
  }

  error(context, e) {
    showDialog(
        context: context,
        builder: (context) {
          String title = "Error";
          print(e.toString());
          if (e.toString() ==
              "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
            setState() {
              print(1);
              title = "Incorrect password";
            }
          }
          return AlertDialog(
            title: Text(title),
            content: Text(e.toString()),
          );
        });
  }

  signInWithPhoneAuthCredential(
      context, PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        return true;
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Wrong OTP")));
      return false;
    }
  }

  validatenumber(context, phonenumber) async {
    if (phonenumber.isNotEmpty && phonenumber.length >= 12) {
      await auth.verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted: (PhoneAuthCredential) async {},
          verificationFailed: (verificationFailed) async {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Verification Failed")));
          },
          codeSent: (verificationId, resendingToken) async {
            this.verificationId = verificationId;
            otpsent = true;
          },
          codeAutoRetrievalTimeout: (verificationId) async {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter valid Phone Number with Country code")));
    }
    return otpsent;
  }

  validateotp(context, TextEditingController otpcontroller) async {
    if (otpcontroller.text.isNotEmpty && otpcontroller.text.length == 6) {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpcontroller.text);
      return signInWithPhoneAuthCredential(context, phoneAuthCredential);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Enter valid OTP"),
      ));
      return false;
    }
  }
}
