import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/data/helper.dart';
import 'package:workhunter/pages/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workhunter/pages/menudashboard.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();
  bool issent = false;
  bool isloading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FireServer fireserver = FireServer();
  Service service = Service();
  late String verificationId;
  int _counter = 10;
  late Timer _timer;
  bool sentonce = false;
  bool isphoneverified = false;
  bool isverifystarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireserver.initialiase();
  }

  void _starttimer() {
    _counter = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  signInWithPhoneAuthCredential(
      context, AuthCredential phoneAuthCredential) async {
    setState(() {});
    try {
      // final authCredential =
      //     await _auth.signInWithCredential(phoneAuthCredential);
      await _auth.currentUser!
          .linkWithCredential(phoneAuthCredential)
          .then((value) {
        setState(() {
          print("Verified");
          isphoneverified = true;
          isverifystarted = false;
        });
      });
      // if (authCredential.user != null) {
      //   setState(() {
      //     isphoneverified = true;
      //     isverifystarted = false;
      //   });

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomeScreen()));

    } on FirebaseAuthException catch (e) {
      print(e);
      service.error(context, e);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Wrong OTP")));
    }
  }

//new additions
  bool isworker = false;
  void changeisworker(value) {
    if (isworker == false) {
      setState(() {
        isworker = true;
      });
    } else {
      setState(() {
        isworker = true;
      });
    }
  }

  bool isimagepicked = false;
  late File pickedimage;
  pickimage() async {
    try {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      setState(() {
        if (image == null) return;
        pickedimage = File(image.path);
        uploadimage(pickedimage);
        isimagepicked = true;

        //http.put has to be called from here
      });
    } on PlatformException catch (e) {
      print("Exception occured in pickimage function $e");
    }
  }

  uploadimage(File file) async {
    final _storage = FirebaseStorage.instance;
    String foldername = _auth.currentUser!.uid;
    //String foldername = "hello";
    var snapshot = await _storage.ref().child('${foldername}/${foldername}');
    await snapshot.putFile(file).whenComplete(() {
      snapshot.getDownloadURL().then((value) {
        //add func here to add to firestore profile data // value is link think so
        downloadurl = value;
        print(value);
      });
    });
  }

  String downloadurl = "";

  TextEditingController professioncontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsoflogin().backtop,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          "Complete Your Profile",
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontFamily: 'Buckin'),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                // Color.fromRGBO(195, 20, 50, 1.0),
                // Color.fromRGBO(36, 11, 54, 1.0)
                colorsoflogin().backtop,
                colorsoflogin().backbottom
              ])),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              height: MediaQuery.of(context).size.height - 130,
              //height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add your profile picture",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isimagepicked == false
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  pickimage();
                                });
                              },
                              child: CircleAvatar(
                                radius: 40,
                                child: Icon(
                                  Icons.person,
                                  size: 38,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  pickimage();
                                });
                              },
                              child: CircleAvatar(
                                foregroundImage: FileImage(pickedimage),
                                radius: 40,
                              ),
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Client",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Switch(
                          value: isworker,
                          onChanged: (value) {
                            setState(() {
                              isworker = value;
                            });
                          }),
                      Text(
                        "Worker",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  _box("Profession", professioncontroller, 50, 2),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 14, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 51,
                          width: 250,
                          margin: EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            autofocus: false,
                            cursorColor: Colors.white,
                            cursorWidth: 1.5,
                            controller: phonenumbercontroller,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter Phone Number here",
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0)),
                            ),
                          ),
                          /*decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(12)),*/
                        ),
                        Container(
                          child: isloading == true
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : issent == true
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.blue,
                                      size: 24,
                                    )
                                  : InkWell(
                                      child: Container(
                                        child: Text(
                                          "Send OTP",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isloading = true;
                                          _validatenumber(context);
                                        });
                                      },
                                    ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.circular(8)),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(top: 8.0),
                    padding: EdgeInsets.only(left: 14, right: 5),
                    child: TextFormField(
                      autofocus: false,
                      cursorColor: Colors.white,
                      cursorWidth: 1.5,
                      controller: otpcontroller,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter OTP here",
                        hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.5)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 0)),
                      ),
                    ),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blueAccent, width: 1.0),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  sentonce == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Didn't get the code?",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey.shade600),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                if (_counter == 0) {
                                  isloading = true;
                                  _validatenumber(context);
                                } else {
                                  print("wait untill count down");
                                }
                              },
                              child:
                                  Text(_counter == 0 ? "Resend" : "$_counter",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                      )),
                            )
                          ],
                        )
                      : SizedBox(
                          height: 5,
                        ),
                  // SizedBox(
                  //   height: 170,
                  // ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () async {
                      if (isphoneverified) {
                        String num = phonenumbercontroller.text;
                        bool status = await fireserver.adddetailstoprofile(
                            isworker == false
                                ? "Client"
                                : professioncontroller.text,
                            phonenumbercontroller.text,
                            downloadurl,
                            _auth.currentUser!.uid);
                        if (status == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuDashboardPage()));
                        }
                      } else {
                        if (downloadurl == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Add Profile picture")));
                        } else {
                          _validateotp(context);
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text(
                          isverifystarted
                              ? "Verifying..."
                              : isphoneverified
                                  ? "Add Details"
                                  : "Verify",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.blueAccent.shade200,
                                Colors.blueAccent.shade200
                              ])),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _cont1() {
    InkWell(
      child: Container(
        child: Text(
          "Send OTP",
          style: TextStyle(
              color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
      onTap: () {
        setState(() {
          isloading = true;
          _validatenumber(context);
        });
      },
    );
  }

  _validatenumber(context) async {
    final userInfo = _auth.currentUser;
    if (phonenumbercontroller.text.isNotEmpty &&
        phonenumbercontroller.text.length >= 12) {
      await _auth.verifyPhoneNumber(
          phoneNumber: phonenumbercontroller.text,
          verificationCompleted: (PhoneAuthCredential) async {
            userInfo!.linkWithCredential(PhoneAuthCredential).then((value) {});
            setState(() {
              isphoneverified = true;
              isverifystarted = false;
              isloading = false;
            });
          },
          verificationFailed: (verificationFailed) async {
            setState(() {
              isloading = false;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Verification Failed")));
          },
          codeSent: (verificationId, resendingToken) async {
            setState(() {
              isloading = false;
              sentonce = true;
              issent = true;
              _starttimer();
              this.verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (verificationId) async {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter valid Phone Number with Country code")));
      setState(() {
        isloading = false;
      });
    }
  }

  _validateotp(context) async {
    if (otpcontroller.text.isNotEmpty && otpcontroller.text.length == 6) {
      AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpcontroller.text);
      signInWithPhoneAuthCredential(context, phoneAuthCredential);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Enter valid OTP"),
      ));
    }
  }

  _box(title, TextEditingController controller, double height, int max) {
    return Container(
        //duration: Duration(milliseconds: 200),
        //margin: const EdgeInsets.all(20),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              color: isworker ? Colors.white : Colors.white.withOpacity(0.5),
              fontFamily: 'Buckin'),
        ),
        Container(
          height: height,
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.only(
            left: 14,
          ),
          decoration: BoxDecoration(
              //color: isworker ? Colors.grey[400] : null,
              border: Border.all(
                  color: isworker ? Colors.blueAccent : Colors.grey,
                  width: 1.0),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TextFormField(
                minLines: 1,
                maxLines: max,
                autofocus: false,
                readOnly: !isworker,
                cursorColor: Colors.white,
                cursorWidth: 1.5,
                controller: controller,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, fontFamily: 'Buckin'),
                decoration: InputDecoration(
                  hintText: isworker ? "Enter Profession here" : "Client",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.5)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                ),
              )),
            ],
          ),
        )
      ],
    ));
  }
}
