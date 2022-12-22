import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/pages/profilepage.dart';

class PostBox extends StatefulWidget {
  final String jobtitle;
  final String location;
  final String PhoneNumber;
  final String Createdby;
  //final bool iscollapsed;
  bool? iscompletedoption;
  String? Createdon;
  String? id;
  //final double Width;
  Function? onTaped;
  PostBox(
      {Key? key,
      required this.location,
      required this.PhoneNumber,
      required this.Createdby,
      this.Createdon = "12 Jan 2022",
      //required this.iscollapsed,
      this.iscompletedoption = false,
      //required this.Width,
      this.id = "",
      this.onTaped,
      required this.jobtitle})
      : super(key: key);

  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  bool tapped = false;

  FireServer fireserver = FireServer();

  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireserver.initialiase();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //tapped = !tapped;
        List checkdocs = [];
        await fireserver
            .readprofiledetails(_auth.currentUser!.uid)
            .then((value) {
          checkdocs = value;
        });
        if (checkdocs[0]['PhoneNumber'] == "") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Complete Profile to check details")));
        } else {
          tapped = !tapped;
          (context as Element).markNeedsBuild();
        }
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        height: tapped ? 170 : 150,
        duration: const Duration(milliseconds: 400),
        //idth: Width,
        child: Column(
          children: [
            Container(
              //height: 180,
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.iscompletedoption == true
                      ? Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  68 -
                                  30 -
                                  1,
                              child: _jobtitletext(),
                            ),
                            PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: Icon(Icons.more_vert_rounded)),
                                itemBuilder: (context) => [
                                      // ignore: prefer_const_constructors
                                      PopupMenuItem(
                                          onTap: () {
                                            fireserver.deleteposts(
                                                widget.id.toString());
                                            fireserver.removepostfromprofile(
                                                widget.id.toString(),
                                                _auth.currentUser!.uid);
                                            print("working at first position");
                                            widget.onTaped;
                                            print("working at 2");
                                          }
                                          // fireserver.deleteposts(
                                          //     widget.id.toString());
                                          // fireserver.removepostfromprofile(
                                          //     widget.id.toString(),
                                          //     _auth.currentUser!.uid);
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ProfilePage()));
                                          ,
                                          height: 40,
                                          //padding: EdgeInsets.only(top: 15),
                                          child: Text("Completed"))
                                    ]),
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  widget.iscompletedoption == false
                      ? _jobtitletext()
                      : SizedBox(
                          width: 0,
                        ),
                  //_payamount(),
                  _locationset(context),
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "posted on : ${widget.Createdon}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            AnimatedContainer(
              height: tapped ? 20 : 0,
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _call(widget.PhoneNumber, widget.Createdby),
              decoration: BoxDecoration(
                  //color: colorsoflogin().backtop,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(17),
                      bottomRight: Radius.circular(17))),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2.5, color: colorsoflogin().backtop)),
      ),
    );
  }

  _payamount() {
    return Row(
      children: [
        RichText(
            text: const TextSpan(
                text: "Pay Amount :",
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
              TextSpan(
                  text: "Negotatable",
                  style: TextStyle(fontSize: 16, color: Colors.black))
            ]))
      ],
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
          tapped
              ? const Icon(
                  Icons.call,
                  size: 20,
                )
              : const SizedBox(width: 0),
          // const Text("+91 7615854682"),
          SizedBox(
            width: 10,
          ),
          tapped
              ? Text(
                  "Call $name",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )
              : SizedBox(width: 0)
        ],
      ),
    );
  }

  _locationset(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on,
          size: 25,
          color: Colors.black,
        ),
        const SizedBox(
          width: 10,
        ),
        // SizedBox(
        //     width: 195,
        //     child: Text(
        //       location,
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w400,
        //         color: Colors.white.withOpacity(0.7),
        //       ),
        //     )
        //     //overflow: TextOverflow.ellipsis),
        //     )
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width - 100,
          child: AutoSizeText(
            widget.location,
            style: TextStyle(fontSize: 20, color: Colors.black),
            maxLines: 3,
          ),
        )
      ],
    );
  }

  _jobtitletext() {
    return Text(
      widget.jobtitle,
      style: TextStyle(
          fontFamily: 'Buckin',
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: Colors.black),
      overflow: TextOverflow.ellipsis,
    );
  }

  _jobtitletext2() {
    return Text(widget.jobtitle,
        style: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
        overflow: TextOverflow.ellipsis);
  }
}

class PostBoxProfile extends StatefulWidget {
  final String jobtitle;
  final String location;
  final String PhoneNumber;
  final String Createdby;
  //final bool iscollapsed;
  bool? iscompletedoption;
  String? Createdon;
  String? id;
  //final double Width;
  Function? onTaped;
  PostBoxProfile(
      {Key? key,
      required this.location,
      required this.PhoneNumber,
      required this.Createdby,
      this.Createdon = "12 Jan 2022",
      //required this.iscollapsed,
      this.iscompletedoption = false,
      //required this.Width,
      this.id = "",
      this.onTaped,
      required this.jobtitle})
      : super(key: key);

  @override
  State<PostBoxProfile> createState() => _PostBoxProfileState();
}

class _PostBoxProfileState extends State<PostBoxProfile> {
  bool tapped = false;

  FireServer fireserver = FireServer();

  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireserver.initialiase();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //tapped = !tapped;
        List checkdocs = [];
        await fireserver
            .readprofiledetails(_auth.currentUser!.uid)
            .then((value) {
          checkdocs = value;
        });
        if (checkdocs[0]['PhoneNumber'] == "") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Complete Profile to check details")));
        } else {
          tapped = !tapped;
          (context as Element).markNeedsBuild();
        }
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        height: tapped ? 170 : 150,
        duration: const Duration(milliseconds: 400),
        //idth: Width,
        child: Column(
          children: [
            Container(
              //height: 180,
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.iscompletedoption == true
                      ? Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  68 -
                                  30 -
                                  1,
                              child: _jobtitletext(),
                            ),
                            PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.white,
                                    )),
                                itemBuilder: (context) => [
                                      // ignore: prefer_const_constructors
                                      PopupMenuItem(
                                          onTap: () {
                                            fireserver.deleteposts(
                                                widget.id.toString());
                                            fireserver.removepostfromprofile(
                                                widget.id.toString(),
                                                _auth.currentUser!.uid);
                                            widget.onTaped;
                                          }
                                          // fireserver.deleteposts(
                                          //     widget.id.toString());
                                          // fireserver.removepostfromprofile(
                                          //     widget.id.toString(),
                                          //     _auth.currentUser!.uid);
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             ProfilePage()));
                                          ,
                                          height: 40,
                                          //padding: EdgeInsets.only(top: 15),
                                          child: Text("Completed"))
                                    ]),
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  widget.iscompletedoption == false
                      ? _jobtitletext()
                      : SizedBox(
                          width: 0,
                        ),
                  //_payamount(),
                  _locationset(context),
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "posted on : ${widget.Createdon}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            AnimatedContainer(
              height: tapped ? 20 : 0,
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _call(widget.PhoneNumber, widget.Createdby),
              decoration: BoxDecoration(
                  //color: colorsoflogin().backtop,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(17),
                      bottomRight: Radius.circular(17))),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2.5, color: Colors.white)),
      ),
    );
  }

  _payamount() {
    return Row(
      children: [
        RichText(
            text: const TextSpan(
                text: "Pay Amount :",
                style: TextStyle(fontSize: 12, color: Colors.white),
                children: [
              TextSpan(
                  text: "Negotatable",
                  style: TextStyle(fontSize: 16, color: Colors.white))
            ]))
      ],
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
          tapped
              ? const Icon(
                  Icons.call,
                  size: 20,
                )
              : const SizedBox(width: 0),
          // const Text("+91 7615854682"),
          SizedBox(
            width: 10,
          ),
          tapped
              ? Text(
                  "Call $name",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              : SizedBox(width: 0)
        ],
      ),
    );
  }

  _locationset(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on,
          size: 25,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        // SizedBox(
        //     width: 195,
        //     child: Text(
        //       location,
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w400,
        //         color: Colors.white.withOpacity(0.7),
        //       ),
        //     )
        //     //overflow: TextOverflow.ellipsis),
        //     )
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width - 100,
          child: AutoSizeText(
            widget.location,
            style: TextStyle(fontSize: 20, color: Colors.white),
            maxLines: 3,
          ),
        )
      ],
    );
  }

  _jobtitletext() {
    return Text(
      widget.jobtitle,
      style: TextStyle(
          fontFamily: 'Buckin',
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: Colors.white),
      overflow: TextOverflow.ellipsis,
    );
  }

  _jobtitletext2() {
    return Text(widget.jobtitle,
        style: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
        overflow: TextOverflow.ellipsis);
  }
}
