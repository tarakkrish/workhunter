import 'package:flutter/material.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/pages/loginpage.dart';
import 'package:workhunter/pages/signuppage.dart';

class WalkInPage extends StatefulWidget {
  const WalkInPage({Key? key}) : super(key: key);

  @override
  State<WalkInPage> createState() => _WalkInPageState();
}

class _WalkInPageState extends State<WalkInPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: colorsoflogin().backbottom,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: colorsoflogin().backtop,
                    height: h - 50,
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 550,
                    width: 550,
                    padding: EdgeInsets.all(0),
                    child: Image.asset(
                      "assets/images/ele4.webp",
                      fit: BoxFit.contain,
                    ),
                  )),
              Positioned(
                  left: 20,
                  right: 20,
                  bottom: 30,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "workhunter.",
                          style: TextStyle(
                              fontFamily: 'Buckin',
                              fontSize: 50,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Text(
                          "Stop waiting for the work and",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          "search for work with the help of our app",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loginui()));
                          },
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      colorsoflogin().loginbutton1,
                                      colorsoflogin().loginbutton2
                                    ])),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                child: Center(
                                  child: const Text(
                                    "Sign up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ),
                                decoration: kInnerDecoration,
                              ),
                            ),
                            height: 55.0,
                            decoration: kGradientBoxDecoration,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  final kInnerDecoration = BoxDecoration(
    color: colorsoflogin().backbottom,
    border: Border.all(color: colorsoflogin().backbottom),
    borderRadius: BorderRadius.circular(32),
  );

  final kGradientBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
        colors: [colorsoflogin().loginbutton1, colorsoflogin().loginbutton2]),
    border: Border.all(
      color: colorsoflogin().backbottom,
    ),
    borderRadius: BorderRadius.circular(32),
  );
}
