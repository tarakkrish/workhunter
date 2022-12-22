import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/main.dart';
import 'package:workhunter/pages/addressform.dart';
import 'package:workhunter/pages/changemailpage.dart';
import 'package:workhunter/pages/loginpage.dart';
import 'package:workhunter/pages/otpveritfication.dart';
import 'package:workhunter/pages/postbox.dart';
import 'package:workhunter/pages/profilepage.dart';
import 'package:workhunter/pages/walkinpage.dart';

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  final _auth = FirebaseAuth.instance;
  String Firstname = "";
  List profiledetails = [];

  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;
  late FireServer server;
  @override
  void initState() {
    super.initState();
    initilaise();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(_controller);
    name();
  }

  name() {
    if (_auth.currentUser != null) {
      String email = _auth.currentUser!.email!;
      server.readprofilefromemail(email).then((value) {
        setState(() {
          profiledetails = value;
        });
      });
      return profiledetails;
    }
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  List docs = [];
  initilaise() {
    server = FireServer();
    server.initialiase();
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
    // server.readprofile().then((value) {
    //   setState(() {
    //     docs = value;
    //   });
    // });
    return docs;
  }

  refresh() {
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
    return docs;
  }

  //new video creation
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    // return Scaffold(
    //   backgroundColor: colorsoflogin().backbottom,
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () async {
    //       await _auth.signOut();
    //       Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => WalkInPage()));
    //     },
    //     child: Icon(Icons.logout),
    //   ),
    //   body: SafeArea(
    //     child: Stack(
    //       children: <Widget>[
    //         menu(context),
    //         dashboard(context),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Stack(
        children: [SideBar(), Dashboarduiplanb()],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                profiledetails.isNotEmpty
                    ? Text("${profiledetails[0]['Firstname']}")
                    : const SizedBox(
                        height: 10,
                      ),
                profiledetails.isNotEmpty
                    ? Text("${profiledetails[0]['createdon']}")
                    : const SizedBox(
                        height: 10,
                      ),
                const Text("Dashboard",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddressForm()));
                  },
                  child: const Text("Add a post",
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
                const SizedBox(height: 10),
                const Text("Change Phone number",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 10),
                const Text("Reset Password",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    await _auth.signOut();
                  },
                  child: Text("Log out",
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isCollapsed) {
                print("nothing");
              } else {
                _controller.reverse();
                isCollapsed = !isCollapsed;
              }
            });
          },
          child: Material(
            animationDuration: duration,
            borderRadius:
                BorderRadius.all(Radius.circular(isCollapsed ? 0 : 40)),
            elevation: 8,
            color: colorsoflogin().backtop,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 40,
                        ),
                        onTap: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();
                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // _post("EEEEEEEEEEEEEEEE",
                  //     "DDDDDGNk jhgsdfuign ihgsngdoi ijiodg"),
                  docs.length == 0
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            double d = double.infinity;
                            return Column(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 3000),
                                  child: PostBox(
                                    jobtitle: docs[index]['NeedOf'],
                                    location: docs[index]['Location'],
                                    PhoneNumber: docs[index]['PhoneNumber'],
                                    Createdby: docs[index]['Createdby'],
                                    //iscollapsed: isCollapsed,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            );
                          },
                        )),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressForm()));
                    },
                    child: Container(
                      child: const Text("ADD POST"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _post(String NeedOf, String Location) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 88,
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            NeedOf,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'Buckin'),
          ),
          Text(
            Location,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  FireServer server = FireServer();
  final _auth = FirebaseAuth.instance;
  List docs = [];
  initialiasesteps() {
    server.initialiase();
    server.readprofiledetails(_auth.currentUser!.uid).then((value) {
      setState(() {
        docs = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiasesteps();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorsoflogin().backbottom,
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 120,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                    child: docs.isNotEmpty
                        ? docs[0]['ProfilePic'] != ""
                            ? CircleAvatar(
                                radius: 25,
                                foregroundImage:
                                    NetworkImage(docs[0]['ProfilePic']),
                              )
                            : CircleAvatar(
                                radius: 25,
                              )
                        : CircleAvatar(
                            radius: 25,
                          ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        docs.isNotEmpty
                            ? Text(
                                docs[0]['Firstname'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Buckin',
                                    color: Colors.white),
                              )
                            : Shimmer.fromColors(
                                child: Skelton(
                                  width: 120,
                                ),
                                baseColor: Colors.white.withOpacity(0.9),
                                highlightColor: colorsoflogin().backtop),
                        SizedBox(
                          height: 5,
                        ),
                        docs.isNotEmpty
                            ? Text(
                                docs[0]['email'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Buckin',
                                    color: Colors.white),
                              )
                            : Shimmer.fromColors(
                                child: Skelton(),
                                baseColor: Colors.white.withOpacity(0.9),
                                highlightColor: colorsoflogin().backtop),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  line(Icons.mail, "Change Email", () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChangeEmail()));
                  }),
                  SizedBox(
                    height: 8,
                  ),
                  line(Icons.person, "Complete Profile", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpVerificationPage()));
                  }),
                  SizedBox(
                    height: 8,
                  ),
                  line(Icons.add_circle_outline_outlined, "Add Post", () async {
                    List checkdocs = [];
                    await server
                        .readprofiledetails(_auth.currentUser!.uid)
                        .then((value) {
                      checkdocs = value;
                    });
                    if (checkdocs.isNotEmpty) {
                      if (checkdocs[0]['PhoneNumber'] == "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: colorsoflogin().backbottom,
                            content: Text("Complete Profile to Add post")));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressForm()));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Complete Profile to Add post")));
                    }
                  }),
                  Expanded(child: Container()),
                  line(
                    Icons.close_rounded,
                    "Logout",
                    () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalkInPage()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  line(IconData icon, String text, GestureTapCallback func) {
    return InkWell(
      onTap: func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'Buckin'),
          )
        ],
      ),
    );
  }
}

class Dashboardui extends StatefulWidget {
  const Dashboardui({Key? key}) : super(key: key);

  @override
  State<Dashboardui> createState() => _DashboarduiState();
}

class _DashboarduiState extends State<Dashboardui> {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  bool isCollapsed = true;
  final _auth = FirebaseAuth.instance;
  String Firstname = "";
  List profiledetails = [];

  final Duration duration = const Duration(milliseconds: 300);
  late FireServer server;
  @override
  void initState() {
    super.initState();
    initilaise();
    name();
  }

  name() {
    if (_auth.currentUser != null) {
      String email = _auth.currentUser!.email!;
      server.readprofilefromemail(email).then((value) {
        setState(() {
          profiledetails = value;
        });
      });
      return profiledetails;
    }
  }

  List docs = [];
  initilaise() {
    server = FireServer();
    server.initialiase();
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
    // server.readprofile().then((value) {
    //   setState(() {
    //     docs = value;
    //   });
    // });
    return docs;
  }

  Future refresh() async {
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.75 : 1.00),
      // ..rotateZ(isDrawerOpen ? pi / 20 : 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isDrawerOpen
              ? BorderRadius.all(Radius.circular(40))
              : BorderRadius.all(Radius.circular(0))),
      child: SafeArea(
        child: Material(
          animationDuration: Duration(milliseconds: 300),
          elevation: 20,
          // color: Colors.red,
          borderRadius:
              BorderRadius.all(Radius.circular(isDrawerOpen ? 40 : 0)),
          child: SafeArea(
              child: Scaffold(
            backgroundColor: colorsoflogin().backbottom,
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: colorsoflogin().backtop,
                  borderRadius: isDrawerOpen
                      ? BorderRadius.all(Radius.circular(40))
                      : BorderRadius.all(Radius.circular(0))),
              child: SingleChildScrollView(
                child: Container(
                  color: colorsoflogin().backtop,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.menu,
                              size: 37,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (isDrawerOpen) {
                                setState(() {
                                  xOffset = 0;
                                  yOffset = 0;
                                  isDrawerOpen = false;
                                });
                              } else {
                                setState(() {
                                  xOffset =
                                      MediaQuery.of(context).size.width - 140;
                                  yOffset =
                                      MediaQuery.of(context).size.height / 4;
                                  isDrawerOpen = true;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      docs.length == 0
                          // ? CircularProgressIndicator()
                          ? Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Shimmer.fromColors(
                                          child: boxstructure(),
                                          baseColor:
                                              Colors.white.withOpacity(0.9),
                                          highlightColor:
                                              colorsoflogin().backtop),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 16,
                                      ),
                                  itemCount: 6),
                            )
                          : Expanded(
                              child: RefreshIndicator(
                              onRefresh: refresh,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  double d = double.infinity;
                                  return Column(
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 3000),
                                        child: PostBox(
                                          jobtitle: docs[index]['NeedOf'],
                                          location: docs[index]['Location'],
                                          PhoneNumber: docs[index]
                                              ['PhoneNumber'],
                                          Createdby: docs[index]['Createdby'],
                                          //iscollapsed: isCollapsed,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  );
                                },
                              ),
                            )),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const AddressForm()));
                      //   },
                      //   child: Container(
                      //     child: const Text("ADD POST"),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}

class Dashboarduiplanbmain extends StatefulWidget {
  const Dashboarduiplanbmain({Key? key}) : super(key: key);

  @override
  State<Dashboarduiplanbmain> createState() => _DashboarduiplanbmainState();
}

class _DashboarduiplanbmainState extends State<Dashboarduiplanbmain>
    with SingleTickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  bool isCollapsed = true;
  final _auth = FirebaseAuth.instance;
  String Firstname = "";
  List profiledetails = [];

  final Duration duration = const Duration(milliseconds: 300);
  late FireServer server;
  @override
  void initState() {
    super.initState();
    initilaise();
    refreshprofiles();
    name();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  name() {
    if (_auth.currentUser != null) {
      String email = _auth.currentUser!.email!;
      server.readprofilefromemail(email).then((value) {
        setState(() {
          profiledetails = value;
        });
      });
      return profiledetails;
    }
  }

  List docs = [];
  initilaise() {
    server = FireServer();
    server.initialiase();
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
    // server.readprofile().then((value) {
    //   setState(() {
    //     docs = value;
    //   });
    // });
    return docs;
  }

  Future refresh() async {
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
  }

  //new additions
  List workerprofiles = [];
  Future refreshprofiles() async {
    server.readworkerprofiles().then((value) {
      workerprofiles = value;
    });
  }

  //icon animation
  late AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  opencls() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      isDrawerOpen ? controller.forward() : controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.75 : 1.00),
      // ..rotateZ(isDrawerOpen ? pi / 20 : 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isDrawerOpen
              ? BorderRadius.all(Radius.circular(40))
              : BorderRadius.all(Radius.circular(0))),
      child: SafeArea(
        child: Material(
          animationDuration: Duration(milliseconds: 300),
          elevation: 20,
          // color: Colors.red,
          borderRadius:
              BorderRadius.all(Radius.circular(isDrawerOpen ? 40 : 0)),
          child: SafeArea(
              child: Scaffold(
            backgroundColor: colorsoflogin().backbottom,
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: colorsoflogin().backtop,
                  borderRadius: isDrawerOpen
                      ? BorderRadius.all(Radius.circular(40))
                      : BorderRadius.all(Radius.circular(0))),
              child: SingleChildScrollView(
                child: Container(
                  color: colorsoflogin().backtop,
                  height: MediaQuery.of(context).size.height,
                  //padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Stack(children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: MediaQuery.of(context).size.height / 5 + 40,
                        bottom: 0,
                        child: profilesside()),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: 0.5,
                        child: ClipPath(
                          clipper: NewWaveClipper(),
                          child: Container(
                            color: colorsoflogin().backbottom,
                            height: MediaQuery.of(context).size.height - 50,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  profilesside() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              child:
                  // Icon(
                  //   Icons.menu,
                  //   size: 37,
                  //   color: Colors.white,
                  // ),
                  AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                size: 40,
                color: Colors.white,
                progress: controller,
              ),
              onTap: () {
                if (isDrawerOpen) {
                  setState(() {
                    opencls();
                    xOffset = 0;
                    yOffset = 0;
                    isDrawerOpen = false;
                  });
                } else {
                  setState(() {
                    xOffset = MediaQuery.of(context).size.width - 140;
                    yOffset = MediaQuery.of(context).size.height / 4;
                    isDrawerOpen = true;
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        workerprofiles.isEmpty
            ? Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Shimmer.fromColors(
                            child: profilesboxstructure(),
                            baseColor: Colors.white.withOpacity(0.9),
                            highlightColor: colorsoflogin().backtop),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 16,
                        ),
                    itemCount: 24),
              )
            : Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Shimmer.fromColors(
                            child: profilesboxstructure(),
                            baseColor: Colors.white.withOpacity(0.9),
                            highlightColor: colorsoflogin().backtop),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 16,
                        ),
                    itemCount: 24),
              )
        //       Expanded(
        //           child: RefreshIndicator(
        //           onRefresh: refreshprofiles,
        //           child: ListView.builder(
        //               itemCount: workerprofiles.length,
        //               itemBuilder: (context, index) {
        //                 if (workerprofiles[index]['Profession'] == "") {
        //                   return SizedBox(
        //                     height: 0,
        //                   );
        //                 } else {
        //                   return Column(
        //                     children: [
        //                       profilebox(
        //                           workerprofiles[index]['ProfilePic'],
        //                           workerprofiles[index]['Profession'],
        //                           "${workerprofiles[index]['Firstname']} ${workerprofiles[index]['Lastname']}",
        //                           workerprofiles[index]['PhoneNumber']),
        //                       SizedBox(
        //                         height: 10,
        //                       )
        //                     ],
        //                   );
        //                 }
        //               }),
        //         )),
        // ],
      ]),
    );
  }

  profilebox(profilepic, proffession, name, number) {
    return Container(
      width: MediaQuery.of(context).size.width - 25,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            foregroundImage: NetworkImage(profilepic),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                proffession,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              _call(number, name)
            ],
          )
        ],
      ),
    );
  }

  _call(String number, String name) {
    return InkWell(
      onTap: () async {
        launch("tel://$number");
        //to call directly without showing number untill call
        //await FlutterPhoneDirectCaller.callNumber("+976446641662");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 15),
          const Icon(
            Icons.call,
            size: 20,
          ),
          // const Text("+91 7615854682"),
          SizedBox(
            width: 10,
          ),
          Text(
            "Call $name",
            style:
                TextStyle(fontSize: 16, color: Colors.black87.withOpacity(0.8)),
          )
        ],
      ),
    );
  }

  postsside() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                child: Icon(
                  Icons.menu,
                  size: 37,
                  color: Colors.white,
                ),
                onTap: () {
                  if (isDrawerOpen) {
                    setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      isDrawerOpen = false;
                    });
                  } else {
                    setState(() {
                      xOffset = MediaQuery.of(context).size.width - 140;
                      yOffset = MediaQuery.of(context).size.height / 4;
                      isDrawerOpen = true;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          docs.length == 0
              // ? CircularProgressIndicator()
              ? Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Shimmer.fromColors(
                              child: profilesboxstructure(),
                              baseColor: Colors.white.withOpacity(0.9),
                              highlightColor: colorsoflogin().backtop),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: 6),
                )
              : Expanded(
                  child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      double d = double.infinity;
                      return Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 3000),
                            child: PostBox(
                              jobtitle: docs[index]['NeedOf'],
                              location: docs[index]['Location'],
                              PhoneNumber: docs[index]['PhoneNumber'],
                              Createdby: docs[index]['Createdby'],
                              //iscollapsed: isCollapsed,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      );
                    },
                  ),
                )),
          // const SizedBox(
          //   height: 20,
          // ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const AddressForm()));
          //   },
          //   child: Container(
          //     child: const Text("ADD POST"),
          //   ),
          // )
        ],
      ),
    );
  }
}

class Dashboarduiplanb extends StatefulWidget {
  const Dashboarduiplanb({Key? key}) : super(key: key);

  @override
  State<Dashboarduiplanb> createState() => _DashboarduiplanbState();
}

class _DashboarduiplanbState extends State<Dashboarduiplanb>
    with SingleTickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  bool isCollapsed = true;
  bool profileside = false;
  final _auth = FirebaseAuth.instance;
  String Firstname = "";
  List profiledetails = [];

  final Duration duration = const Duration(milliseconds: 300);
  late FireServer server;
  @override
  void initState() {
    super.initState();
    initilaise();
    refreshprofiles();
    name();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  }

  name() {
    if (_auth.currentUser != null) {
      String email = _auth.currentUser!.email!;
      server.readprofilefromemail(email).then((value) {
        setState(() {
          profiledetails = value;
        });
      });
      return profiledetails;
    }
  }

  List docs = [];
  initilaise() {
    server = FireServer();
    server.initialiase();
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
    // server.readprofile().then((value) {
    //   setState(() {
    //     docs = value;
    //   });
    // });
    return docs;
  }

  Future refresh() async {
    server.readposts().then((value) {
      setState(() {
        docs = value;
      });
    });
  }

  //new additions
  List workerprofiles = [];
  Future refreshprofiles() async {
    server.readworkerprofiles().then((value) {
      workerprofiles = value;
    });
  }

  Future refreshtwoitems() async {
    refresh();
    refreshprofiles();
  }

  //icon animation
  late AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  opencls() {
    setState(() {
      isDrawerOpen == false ? controller.forward() : controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.75 : 1.00),
      // ..rotateZ(isDrawerOpen ? pi / 20 : 0),
      decoration: BoxDecoration(
          color: colorsoflogin().backtop,
          borderRadius: isDrawerOpen
              ? BorderRadius.all(Radius.circular(40))
              : BorderRadius.all(Radius.circular(0))),
      child: SafeArea(
        child: Material(
          animationDuration: Duration(milliseconds: 300),
          elevation: 20,
          // color: Colors.red,
          borderRadius:
              BorderRadius.all(Radius.circular(isDrawerOpen ? 40 : 0)),
          child: SafeArea(
              child: Scaffold(
            backgroundColor: colorsoflogin().backbottom,
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: colorsoflogin().backtop,
                  borderRadius: isDrawerOpen
                      ? BorderRadius.all(Radius.circular(40))
                      : BorderRadius.all(Radius.circular(0))),
              child: SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    // padding: EdgeInsets.only(
                    //     left: 15, right: 15, top: 15, bottom: 25),
                    child: RefreshIndicator(
                      onRefresh: refreshtwoitems,
                      edgeOffset: 100,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            backgroundColor: colorsoflogin().backbottom,
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  child:
                                      // Icon(
                                      //   Icons.menu,
                                      //   size: 37,
                                      //   color: Colors.white,
                                      // ),
                                      AnimatedIcon(
                                    icon: AnimatedIcons.menu_close,
                                    size: 40,
                                    color: Colors.white,
                                    progress: controller,
                                  ),
                                  onTap: () {
                                    if (isDrawerOpen) {
                                      setState(() {
                                        opencls();
                                        xOffset = 0;
                                        yOffset = 0;
                                        isDrawerOpen = false;
                                      });
                                    } else {
                                      setState(() {
                                        opencls();
                                        xOffset =
                                            MediaQuery.of(context).size.width -
                                                140;
                                        yOffset =
                                            MediaQuery.of(context).size.height /
                                                4;
                                        isDrawerOpen = true;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            floating: true,
                            expandedHeight: 170,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Stack(children: [
                                Positioned(
                                    child: Opacity(
                                  opacity: 1,
                                  child: ClipPath(
                                    clipper: NewWave2Clipper(),
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                                Opacity(
                                  opacity: 1,
                                  child: ClipPath(
                                    clipper: NewWaveClipper(),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: isDrawerOpen
                                          ? colorsoflogin().backtop
                                          : colorsoflogin().backbottom,
                                      //height: MediaQuery.of(context).size.height - 50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Container(
                                            width: 218,
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                bottom: 7,
                                                top: 7),
                                            // margin: EdgeInsets.only(
                                            //     left: 40, right: 40),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                color: isDrawerOpen == false
                                                    ? colorsoflogin().backtop
                                                    : colorsoflogin()
                                                        .backbottom),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      profileside = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 5,
                                                        top: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        color: profileside ==
                                                                isDrawerOpen
                                                            ? colorsoflogin()
                                                                .backbottom
                                                            : colorsoflogin()
                                                                .backtop),
                                                    child: Text(
                                                      "Posts",
                                                      style: TextStyle(
                                                          fontFamily: 'Buckin',
                                                          fontSize: 28,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      profileside = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 5,
                                                        top: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        color: profileside ==
                                                                isDrawerOpen
                                                            ? colorsoflogin()
                                                                .backtop
                                                            : colorsoflogin()
                                                                .backbottom),
                                                    child: Text(
                                                      "Profiles",
                                                      style: TextStyle(
                                                          fontFamily: 'Buckin',
                                                          fontSize: 28,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (profileside == false) {
                                  return docs.length == 0
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Shimmer.fromColors(
                                              child: boxstructure(),
                                              baseColor:
                                                  Colors.white.withOpacity(0.9),
                                              highlightColor:
                                                  colorsoflogin().backtop),
                                        )
                                      : Column(
                                          children: [
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 3000),
                                              child: PostBox(
                                                jobtitle: docs[index]['NeedOf'],
                                                location: docs[index]
                                                    ['Location'],
                                                PhoneNumber: docs[index]
                                                    ['PhoneNumber'],
                                                Createdby: docs[index]
                                                    ['Createdby'],
                                                Createdon: (docs[index]
                                                            ['Createdon']
                                                        as Timestamp)
                                                    .toDate()
                                                    .toString()
                                                    .substring(0, 16),
                                                //iscollapsed: isCollapsed,
                                              ),
                                            ),
                                            SizedBox(
                                              height: index == docs.length - 1
                                                  ? 40
                                                  : 15,
                                            )
                                          ],
                                        );
                                } else {
                                  return workerprofiles.isEmpty
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              child: Shimmer.fromColors(
                                                  child: profilesboxstructure(),
                                                  baseColor: Colors.white
                                                      .withOpacity(0.9),
                                                  highlightColor:
                                                      colorsoflogin().backtop),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            )
                                          ],
                                        )
                                      : workerprofiles[index]['Profession'] ==
                                              ""
                                          ? SizedBox(
                                              height: 0,
                                            )
                                          : Column(
                                              children: [
                                                profilebox(
                                                    workerprofiles[index]
                                                        ['ProfilePic'],
                                                    workerprofiles[index]
                                                        ['Profession'],
                                                    "${workerprofiles[index]['Firstname']} ${workerprofiles[index]['Lastname']}",
                                                    workerprofiles[index]
                                                        ['PhoneNumber']),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            );
                                }
                              },
                              childCount: profileside
                                  ? workerprofiles.length
                                  : docs.length,
                            ),
                          )
                        ],
                      ),
                    )
                    //Stack(children: [

                    //   Positioned(
                    //       left: 0,
                    //       right: 0,
                    //       top: 0,
                    //       bottom: 0,
                    //       child: profilesside()),
                    //   Positioned(
                    //     top: MediaQuery.of(context).size.height / 5 + 40,
                    //     left: 0,
                    //     right: 0,
                    //     child:
                    // Opacity(
                    //       opacity: 0.5,
                    //       child: ClipPath(
                    //         clipper: NewWaveClipper(),
                    //         child: Container(
                    //           color: colorsoflogin().backbottom,
                    //           height: MediaQuery.of(context).size.height - 50,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ]),
                    ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  profilesside() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        workerprofiles.isEmpty
            ? Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Shimmer.fromColors(
                            child: profilesboxstructure(),
                            baseColor: Colors.white.withOpacity(0.9),
                            highlightColor: colorsoflogin().backtop),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: 16,
                        ),
                    itemCount: 24),
              )
            : Expanded(
                child: RefreshIndicator(
                onRefresh: refreshprofiles,
                child: ListView.builder(
                    itemCount: workerprofiles.length,
                    itemBuilder: (context, index) {
                      if (workerprofiles[index]['Profession'] == "") {
                        return SizedBox(
                          height: 0,
                        );
                      } else {
                        return Column(
                          children: [
                            profilebox(
                                workerprofiles[index]['ProfilePic'],
                                workerprofiles[index]['Profession'],
                                "${workerprofiles[index]['Firstname']} ${workerprofiles[index]['Lastname']}",
                                workerprofiles[index]['PhoneNumber']),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }
                    }),
              )),
        // ],
      ]),
    );
  }

  profilebox(profilepic, proffession, name, number) {
    return Container(
      width: MediaQuery.of(context).size.width - 25,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            foregroundImage: NetworkImage(profilepic),
          ),
          SizedBox(
            width: 25,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proffession,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              _call(number, name)
            ],
          )
        ],
      ),
    );
  }

  _call(String number, String name) {
    return InkWell(
      onTap: () async {
        launch("tel://$number");
        //to call directly without showing number untill call
        //await FlutterPhoneDirectCaller.callNumber("+976446641662");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.call,
            size: 20,
          ),
          // const Text("+91 7615854682"),
          SizedBox(
            width: 10,
          ),
          Text(
            "Call $name",
            style:
                TextStyle(fontSize: 16, color: Colors.black87.withOpacity(0.8)),
          )
        ],
      ),
    );
  }

  postsside() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          docs.length == 0
              // ? CircularProgressIndicator()
              ? Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Shimmer.fromColors(
                              child: profilesboxstructure(),
                              baseColor: Colors.white.withOpacity(0.9),
                              highlightColor: colorsoflogin().backtop),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: 6),
                )
              : Expanded(
                  child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      double d = double.infinity;
                      return Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 3000),
                            child: PostBox(
                              jobtitle: docs[index]['NeedOf'],
                              location: docs[index]['Location'],
                              PhoneNumber: docs[index]['PhoneNumber'],
                              Createdby: docs[index]['Createdby'],
                              //iscollapsed: isCollapsed,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      );
                    },
                  ),
                )),
          // const SizedBox(
          //   height: 20,
          // ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const AddressForm()));
          //   },
          //   child: Container(
          //     child: const Text("ADD POST"),
          //   ),
          // )
        ],
      ),
    );
  }
}

class profilesboxstructure extends StatelessWidget {
  const profilesboxstructure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 8),
        child: Row(
          children: [
            CircleAvatar(
              foregroundColor: Colors.black.withOpacity(0.04),
              radius: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Skelton(
                  width: 200,
                  height: 30,
                ),
                SizedBox(
                  height: 8,
                ),
                Skelton(
                  width: 150,
                )
              ],
            )
          ],
        ));
  }
}

class boxstructure extends StatelessWidget {
  const boxstructure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        border: Border.all(width: 5, color: Colors.white.withOpacity(0.04)),
      ),
      padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skelton(
            width: 250,
            height: 25,
          ),
          const SizedBox(
            height: 10,
          ),
          Skelton(),
          const SizedBox(
            height: 8,
          ),
          Skelton(),
          SizedBox(
            height: 8,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Skelton(
                width: 120,
              )
            ],
          )
        ],
      ),
    );
  }
}

class Skelton extends StatelessWidget {
  Skelton({Key? key, this.height, this.width}) : super(key: key);
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}
