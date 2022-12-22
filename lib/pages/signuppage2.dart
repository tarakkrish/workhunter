import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/data/helper.dart';
import 'package:workhunter/pages/loginpage.dart';
import 'package:workhunter/pages/menudashboard.dart';
import 'package:workhunter/pages/profilepage.dart';
import 'package:workhunter/pages/signuppage.dart';
import 'package:workhunter/pages/verifyemail.dart';

class Signup2 extends StatefulWidget {
  final String Firstname, Lastname, password;
  const Signup2(
      {Key? key,
      required this.Firstname,
      required this.Lastname,
      required this.password})
      : super(key: key);

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  Service service = Service();
  Verifyemail verifyemail = Verifyemail();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController emailotpcontroller = new TextEditingController();
  TextEditingController mobilecontroller = new TextEditingController();
  TextEditingController mobileotpcontroller = new TextEditingController();
  bool sendemail = false;
  bool sendphnotp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: colorsoflogin().backbottom,
          height: MediaQuery.of(context).size.height,
          child: verifications(),
        ),
      ),
    );
  }

  verifications() {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: const Color.fromARGB(255, 36, 41, 81),
              height: MediaQuery.of(context).size.height - 50,
            ),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 1000,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    const Text(
                      " jobstack.",
                      style: TextStyle(
                          fontFamily: 'Buckin',
                          fontSize: 50,
                          color: Color.fromARGB(255, 83, 92, 185)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 18, color: colorsoflogin().sidehead1),
                        ),
                        sendemail == false
                            ? InkWell(
                                onTap: () {
                                  emailotp(emailcontroller.value.text);
                                },
                                child: const Text(
                                  "Send",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue),
                                ),
                              )
                            : const Text(
                                "Sent",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )
                      ],
                    ),
                    field(emailcontroller, "Enter email here", false),
                    Text(
                      "Email OTP",
                      style: TextStyle(
                          fontSize: 18, color: colorsoflogin().sidehead1),
                    ),
                    field(emailotpcontroller, "Enter email otp here", false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Mobile Number",
                          style: TextStyle(
                              fontSize: 18, color: colorsoflogin().sidehead1),
                        ),
                        InkWell(
                          onTap: () {
                            mobileotp(mobilecontroller.text);
                          },
                          child: const Text(
                            "Send",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                    field(mobilecontroller, "Enter email here", false),
                    Text(
                      "Mobile OTP",
                      style: TextStyle(
                          fontSize: 18, color: colorsoflogin().sidehead1),
                    ),
                    field(mobileotpcontroller, "Enter email here", false),
                    //Spacer(),
                    InkWell(
                      onTap: () {
                        dynamic e = verifyemail.verify(
                            emailcontroller.text, emailotpcontroller.text);
                        dynamic m =
                            service.validateotp(context, mobileotpcontroller);
                        if (e == true) {
                        } else {
                          print("email otp not matched");
                        }
                        if (m == true) {
                        } else {
                          print("mobile otp not matched");
                        }
                        if (e == true && m == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()));
                        }
                        // have to add createuser and profile details here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 7, right: 7),
                        height: 50,
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  colorsoflogin().loginbutton1,
                                  colorsoflogin().loginbutton2
                                ])),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  mobileotp(phonenumber) {
    print(service.validatenumber(context, phonenumber));
  }

  emailotp(email) {
    if (emailcontroller.text.isEmpty) {
      service.error(context, "Email Field can't be empty");
    } else {
      print(verifyemail.sendOtp(email));
      if (verifyemail.sendOtp(email) == true) {
        setState(() {
          sendemail = true;
        });
      }
    }
  }
}

class Emailotpverification extends StatefulWidget {
  final TextEditingController emailcontroller;
  final String Firstname;
  final String Lastname;
  final String password;

  const Emailotpverification(
      {Key? key,
      required this.Firstname,
      required this.Lastname,
      required this.password,
      required this.emailcontroller})
      : super(key: key);

  @override
  State<Emailotpverification> createState() => _EmailotpverificationState();
}

class _EmailotpverificationState extends State<Emailotpverification> {
  Service service = Service();
  FireServer fireserver = FireServer();
  Verifyemail verifyemail = Verifyemail();
  final _auth = FirebaseAuth.instance;
  String _code = "";
  TextEditingController otpcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireserver = FireServer();
    fireserver.initialiase();
    //verifyemail.sendOtp(widget.emailcontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: colorsoflogin().backbottom,
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Verify Email",
                style: TextStyle(
                    fontFamily: "Buckin",
                    fontSize: 35,
                    color: colorsoflogin().title),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                  height: 250,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Image.asset(
                    "assets/images/verifyemail3.png",
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                height: 0,
              ),
              Text("We have just send you 6 digit ", style: txtstyl()),
              Text(
                "code via your email",
                style: txtstyl(),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 30,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: colorsoflogin().backtop,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerificationCode(
                      itemSize: 35,
                      digitsOnly: true,
                      textStyle:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                      keyboardType: TextInputType.number,
                      underlineColor: colorsoflogin()
                          .subtitle, // If this is null it will use primaryColor: Colors.red from Theme
                      length: 6,
                      cursorColor: Colors
                          .blue, // If this is null it will default to the ambient
                      // clearAll is NOT required, you can delete it
                      // takes any widget, so you can implement your design
                      onCompleted: (String value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      onEditing: (bool value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_code != null) {
                          bool sent = verifyemail.verify(
                              widget.emailcontroller.text, _code);
                          if (sent == true) {
                            bool status = await service.createUser(
                                widget.emailcontroller.text,
                                widget.password,
                                context);
                            if (status == true) {
                              fireserver.createprofile(
                                  widget.Firstname,
                                  widget.Lastname,
                                  widget.emailcontroller.text,
                                  _auth.currentUser!.uid);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          MenuDashboardPage())));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => ProfilePage())));
                            }
                          } else {
                            service.error(context, "Incorrect OTP");
                          }
                        } else {
                          service.error(context, "Please enter 6 digits otp!");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: const Text(
                          "Verify",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorsoflogin().loginbutton1,
                                  colorsoflogin().loginbutton2
                                ])),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Didn't receive code?",
                style: txtstyl(),
              ),
              InkWell(
                onTap: () {
                  verifyemail.sendOtp(widget.emailcontroller.text);
                },
                child: Text(
                  "Re-send",
                  style: txtstyl(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  txtstyl() {
    return const TextStyle(fontSize: 16, color: Colors.white);
  }
}
