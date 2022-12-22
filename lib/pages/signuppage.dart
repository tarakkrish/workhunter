import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/data/helper.dart';
import 'package:workhunter/pages/loginpage.dart';
import 'package:workhunter/pages/postbox.dart';
import 'package:workhunter/pages/profilepage.dart';
import 'package:workhunter/pages/signuppage2.dart';
import 'package:workhunter/pages/verifyemail.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return const Mobilesignup();
        } else {
          return const Desktopsignup();
        }
      },
    );
  }
}

class Mobilesignup extends StatefulWidget {
  const Mobilesignup({Key? key}) : super(key: key);

  @override
  _MobilesignupState createState() => _MobilesignupState();
}

class _MobilesignupState extends State<Mobilesignup> {
  final formkey = GlobalKey<FormState>();
  String aadharcard = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      //height: 700,
      //width: 400,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Container(
          height: 800,
          child: Column(
            children: [
              const SizedBox(
                height: 100,
                width: 500,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "SIGNUP",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // PostBox(
              //     location: "Delhi,125255",
              //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
              // SizedBox(
              //   height: 20,
              // ),
              // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
              Form(
                  key: formkey,
                  child: Expanded(
                    child: ListView(
                      children: [
                        aadharfield(),
                        const SizedBox(
                          height: 50,
                        ),
                        button(),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    )));
  }

  Widget aadharfield() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Aadhar Card Number",
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value?.length != 12) {
            return 'Enter valid 12 digit aadhar number';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() {
          aadharcard = value.toString();
        }),
      );
  Widget button() {
    return InkWell(
      onTap: () {
        final isValid = formkey.currentState?.validate();
        if ((isValid != null) && (isValid != false)) {
          formkey.currentState?.save();
        }
      },
      child: Container(
        height: 150,
        child: const Text("Done"),
      ),
    );
  }
}

class Desktopsignup extends StatefulWidget {
  const Desktopsignup({Key? key}) : super(key: key);

  @override
  _DesktopsignupState createState() => _DesktopsignupState();
}

class _DesktopsignupState extends State<Desktopsignup> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late FireServer fireserver;
  bool passwordvisible = false;
  Service service = Service();
  FireServer server = FireServer();
  Verifyemail verifyemail = Verifyemail();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController repasswordcontroller = new TextEditingController();
  TextEditingController firstnamecontroller = new TextEditingController();
  TextEditingController lastnamecontroller = new TextEditingController();
  TextEditingController workprofessioncontroller = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireserver = FireServer();
    fireserver.initialiase();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: h, color: Color.fromARGB(255, 26, 30, 61), child: newre()),
      ),
    );
  }

  newre() {
    return Stack(children: [
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
          padding: EdgeInsets.all(15.0),
          height: 994 + 200,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 75,
                ),
                const Text(
                  "workhunter.",
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
                SizedBox(
                  height: 15,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   margin: EdgeInsets.symmetric(horizontal: 40),
                //   child: TextField(
                //     decoration: InputDecoration(labelText: "Email"),
                //   ),
                // ),
                Text(
                  "First name",
                  style:
                      TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
                ),
                field(firstnamecontroller, "Enter First name here", false),

                Text(
                  "Last name",
                  style:
                      TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
                ),
                field(lastnamecontroller, "Enter last name here", false),
                Text(
                  "Email",
                  style:
                      TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
                ),
                field(emailcontroller, "Enter email here", false),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Password",
                  style:
                      TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
                ),
                Container(
                  //width: 215,
                  height: 45,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    obscureText: !passwordvisible,
                    controller: passwordcontroller,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Enter Password here",
                        hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            //fontFamily: 'Tommy_medium',
                            color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 83, 92, 185),
                                width: 2.0)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 83, 92, 185),
                              width: 3.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordvisible = !passwordvisible;
                            });
                          },
                          icon: Icon(
                            passwordvisible
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                          color: Colors.white,
                          iconSize: 20,
                        )),
                  ),
                ),
                Text(
                  "Re-enter Password",
                  style:
                      TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
                ),
                Container(
                  //width: 215,
                  height: 45,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    obscureText: true,
                    controller: repasswordcontroller,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Re-Enter Password here",
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          //fontFamily: 'Tommy_medium',
                          color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 83, 92, 185),
                              width: 2.0)),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 83, 92, 185),
                            width: 3.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Text(
                //   "Work Profession",
                //   style:
                //       TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
                // ),
                // field(workprofessioncontroller, "Enter your profession", true),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                    children: [
                      TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Clicked Terms of Service');
                            }),
                      const TextSpan(text: ' and '),
                      TextSpan(
                          text: "Pirvacy Policy",
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('clicked Pirvacy Policy');
                            }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    if (passwordcontroller.text.isEmpty ||
                        repasswordcontroller.text.isEmpty ||
                        emailcontroller.text.isEmpty ||
                        firstnamecontroller.text.isEmpty ||
                        lastnamecontroller.text.isEmpty) {
                      print("Fields can't be empty");
                    } else {
                      if (passwordcontroller.text !=
                          repasswordcontroller.text) {
                        print("Passwords did not match");
                      } else {
                        // bool status = await service.createUser(
                        //     emailcontroller.text,
                        //     passwordcontroller.text,
                        //     context);
                        // if (status == true) {
                        //   fireserver.createprofile(firstnamecontroller.text,
                        //       lastnamecontroller.text, emailcontroller.text);
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: ((context) => const ProfilePage())));
                        // }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Signup2(
                        //               Firstname: firstnamecontroller.text,
                        //               Lastname: lastnamecontroller.text,
                        //               password: passwordcontroller.text,
                        //             )));

                        // uncomment this to add verification otp
                        bool sent =
                            await verifyemail.sendOtp(emailcontroller.text);
                        if (sent == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Emailotpverification(
                                        Firstname: firstnamecontroller.text,
                                        Lastname: lastnamecontroller.text,
                                        password: passwordcontroller.text,
                                        emailcontroller: emailcontroller,
                                      )));
                        } else {
                          print("something went wrong at sending otp ");
                        }
                      }
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    margin: const EdgeInsets.only(left: 7, right: 7),
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Next",
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
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Login',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Loginui()));
                              }),
                      ],
                    ),
                  ),
                ]),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  height: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
    ;
  }
}

field(TextEditingController controller, String hinttxt, bool readbool) {
  return Container(
    //width: 215,
    height: 40,
    margin: EdgeInsets.only(top: 5, bottom: 5),
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
    child: TextField(
      textInputAction: TextInputAction.next,
      readOnly: readbool,
      controller: controller,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      decoration: InputDecoration(
        hintText: hinttxt,
        hintStyle: TextStyle(
            fontSize: 16,
            //fontFamily: 'Tommy_medium',
            fontWeight: FontWeight.w400,
            color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 2.0, color: Color.fromARGB(255, 83, 92, 185))),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 3.0, color: Color.fromARGB(255, 83, 92, 185)),
        ),
      ),
    ),
  );
}
