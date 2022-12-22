import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/helper.dart';
import 'package:workhunter/pages/createanaccountpage.dart';
import 'package:workhunter/pages/verifyemail.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Service service = Service();
  final auth = FirebaseAuth.instance;
  dynamic errocode;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: h * 0.3,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
                child: Text("Login"),
                onTap: () {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    print(0);
                    service.loginUser(
                        emailController.text, passwordController.text, context);
                    print(1);
                  } else {
                    service.error(context, "Fields must not be empty");
                  }
                  // auth
                  //     .signInWithEmailAndPassword(
                  //         email: emailController.text,
                  //         password: passwordController.text)
                  //     //  await firebase.auth().signInWithEmailAndPassword(email, password)
                  //     .then((data) => {print(data)})
                  //     .catchError((error) {
                  //   errocode = error.code;
                  //   if (errocode == 'auth/wrong-password') {
                  //     print('Wrong password.');
                  //   } else {
                  //     print("error message");
                  //   }
                  //   // try {
                  //   //   auth.signInWithEmailAndPassword(
                  //   //       email: emailController.text,
                  //   //       password: passwordController.text);
                  //   // }catch (e) {
                  //   //   print(e);
                  //   // }

                  //   print("hi hello bro");
                  // });
                })
          ],
        ),
      )),
    );
  }
}

class Loginui extends StatefulWidget {
  const Loginui({Key? key}) : super(key: key);

  @override
  State<Loginui> createState() => _LoginuiState();
}

class _LoginuiState extends State<Loginui> {
  Service service = Service();
  bool passwordvisible = false;
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colorsoflogin().backbottom,
      body: SingleChildScrollView(
        child: Container(
            height: h, color: colorsoflogin().backbottom, child: newre()),
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
            color: colorsoflogin().backtop,
            height: MediaQuery.of(context).size.height - 50,
          ),
        ),
      ),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (emailcontroller.text.isNotEmpty &&
                        passwordcontroller.text.isNotEmpty) {
                      print(0);
                      service.loginUser(emailcontroller.text,
                          passwordcontroller.text, context);
                      print(1);
                    } else {
                      service.error(context, "Fields must not be empty");
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    height: 50,
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(255, 58, 65, 130),
                              Color.fromARGB(255, 83, 91, 182)
                            ])),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )),
      Positioned(
        left: 0,
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(15.0),
          height: 564,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                "workhunter.",
                style: TextStyle(
                    fontFamily: 'Buckin',
                    fontSize: 50,
                    color: colorsoflogin().title),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Welcome back!",
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
              const Text(
                "Email",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),

              Container(
                //width: 215,
                height: 45,
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: emailcontroller,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter email here",
                    hintStyle: TextStyle(
                        fontSize: 18,
                        //fontFamily: 'Tommy_medium',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Color.fromARGB(255, 83, 92, 185))),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 3.0, color: Color.fromARGB(255, 83, 92, 185)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Password",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Container(
                //width: 215,
                height: 55,
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  obscureText: !passwordvisible,
                  controller: passwordcontroller,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Enter Password here",
                      hintStyle: const TextStyle(
                          fontSize: 18,
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
                        iconSize: 30,
                      )),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (emailcontroller.text.isNotEmpty) {
                        service.forgotpassword(emailcontroller.text, context);
                      } else {
                        service.error(context, "Email Field can't be empty");
                      }
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    ]);
    ;
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = new Path();
    path.lineTo(0, size.height / 2);
    var firstStart = Offset(size.width * 0.6, size.height * 0.65);
    var firstEnd = Offset(size.width, size.height * 0.25);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    /*var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);*/
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
    // TODO: implement shouldReclip
    //throw UnimplementedError();
  }
}

class NewWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = new Path();
    path.lineTo(0, size.height - 20 - 70);
    var firstStart = Offset(size.width * 0.07, size.height + 20 - 70);
    var firstEnd = Offset(size.width * 0.15, size.height + 22 - 70);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    path.lineTo(size.width * 0.85, size.height + 22 - 70);
    var secondStart = Offset(size.width * 0.95, size.height + 24 - 70);
    var secondEnd = Offset(size.width, size.height + 70 - 70);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    //path.lineTo(size.width, size.height / 5 + 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
    // TODO: implement shouldReclip
    //throw UnimplementedError();
  }
}

class NewWave2Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = new Path();
    path.lineTo(0, size.height - 20 - 70);
    var firstStart = Offset(size.width * 0.07, size.height + 20 - 70);
    var firstEnd = Offset(size.width * 0.15, size.height + 22 - 70);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    path.lineTo(size.width * 0.85, size.height + 22 - 70);
    var secondStart = Offset(size.width * 0.95, size.height + 24 - 70);
    var secondEnd = Offset(size.width, size.height + 70 - 70);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    //path.lineTo(size.width, size.height / 5 + 60);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
    // TODO: implement shouldReclip
    //throw UnimplementedError();
  }
}
