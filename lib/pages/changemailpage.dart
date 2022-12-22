import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/data/helper.dart';
import 'package:workhunter/pages/signuppage.dart';
import 'package:workhunter/pages/walkinpage.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isopen = false;
  Service service = Service();
  FireServer server = FireServer();
  final _auth = FirebaseAuth.instance;
  TextEditingController newmailcontroller = new TextEditingController();
  TextEditingController currentpasswordcontroller = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    server.initialiase();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  opencls() {
    setState(() {
      isopen = !isopen;
      isopen ? controller.forward() : controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsoflogin().backtop,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    opencls();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 50,
              ),
              Text(
                "New Email",
                style:
                    TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
              ),
              field(newmailcontroller, "newmail@gmail.com", false),
              Text(
                "Current Password",
                style:
                    TextStyle(fontSize: 18, color: colorsoflogin().sidehead1),
              ),
              field(currentpasswordcontroller, "Enter current password", false),
              InkWell(
                onTap: () async {
                  if (newmailcontroller.text.isNotEmpty &&
                      currentpasswordcontroller.text.isNotEmpty) {
                    bool status = await service.changemail(
                        newmailcontroller.text,
                        currentpasswordcontroller.text,
                        context);
                    if (status == true) {
                      print(
                          "your doubt may be true about async and await in changemail");
                      // await server.updatemailtoprofile(newmailcontroller.text);
                      _auth.signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalkInPage()));
                      });
                    }
                  }
                },
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
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
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
      )),
    );
  }
}
