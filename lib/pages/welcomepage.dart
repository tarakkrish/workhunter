import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workhunter/colors/colorsofpage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _initialvalue = 0.0;

  void update() {
    Timer timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (this.mounted) {
        setState(() {
          if (_initialvalue >= 0.8) {
            timer.cancel();
            //Navigator.popAndPushNamed(context, 'InitialPage');
          } else {
            _initialvalue = _initialvalue + 0.1;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    update();
    return Scaffold(
      backgroundColor: colorsoflogin().backtop, //ColorCodes.background,
      body: Container(
        height: MediaQuery.of(context).size.height * 58,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.42, left: 10),
        child: Column(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      child: FittedBox(
                        child: Text("WORKHUNTER",
                            style: TextStyle(
                                fontFamily: 'StayBold',
                                fontWeight: FontWeight.w800,
                                fontSize: 70,
                                color: colorsoflogin()
                                    .backbottom //ColorCodes.headtextcolor,
                                )),
                      ),
                    ),
                  ),
                  const Positioned(
                      left: 0,
                      right: 0,
                      top: 20,
                      bottom: 0,
                      child: Text(
                        "Welcomes You",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'La_Storia',
                            fontSize: 10,
                            color: Colors.white),
                      )),
                ],
              ),
            ),
            /* Divider(
              color: ColorCodes.headtextcolor,
              height: 10,
              thickness: 8,
              indent: 12,
              endIndent: MediaQuery.of(context).size.width * 0.6 - 34,
            ),*/
            Container(
              padding: EdgeInsets.only(left: 17),
              child: LinearProgressIndicator(
                color: colorsoflogin().backbottom, //ColorCodes.headtextcolor,
                backgroundColor:
                    colorsoflogin().backtop, //ColorCodes.background,
                value: _initialvalue,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
