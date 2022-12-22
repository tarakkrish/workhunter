import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/pages/addressform.dart';
import 'package:workhunter/pages/menudashboard.dart';
import 'package:workhunter/pages/postbox.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late FireServer server;
  // List docs = [
  //   {
  //     "id": "sfsg",
  //     "Firstname": "Krishnas",
  //     "Lastname": "Tarak",
  //     "createdon": "fsf"
  //   }
  // ];
  // Timestamp createdon = 1628528400 as Timestamp;
  List docs = [];
  List doc = [];
  bool loaded = false;
  initilaise() {
    server = FireServer();
    final _auth = FirebaseAuth.instance;
    server.initialiase();
    beforerefresh();

    // server.readprofile().then((value) {
    //   setState(() {
    //     docs = value;
    //   });
    // });
    return docs;
  }

  Future beforerefresh() async {
    server.readprofilepostsfromid(_auth.currentUser!.uid).then((value) {
      final List dee = value;
      print("$dee ,sfjkknferuvg");
      setState(() {
        docs = value;
      });
      refresh(docs[0]);
    });
  }

  refresh(id) {
    server.readpostsbyids(id).then((value) {
      setState(() {
        doc = value;
        loaded = true;
      });
    });
    return doc;
  }

  FireServer fireserver = FireServer();

  final _auth = FirebaseAuth.instance;

  // refresher(id) {
  //   server.readprofilepostsfromid(id).then((value) {
  //     setState(() {
  //       doc = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilaise();
  }

  bool isCollapsed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => AddressForm()));
      // }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            height: MediaQuery.of(context).size.height,
            color: colorsoflogin().backtop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, bottom: 15, top: 15),
                      child: Text(
                        "Posts",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 20.0, bottom: 15, top: 15),
                //   child: Text(
                //     "Posts",
                //     style: TextStyle(
                //         fontSize: 28,
                //         color: Colors.white,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),
                loaded == false
                    ? Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Shimmer.fromColors(
                                    child: boxstructure(),
                                    baseColor: Colors.white.withOpacity(0.9),
                                    highlightColor: colorsoflogin().backtop),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 16,
                                ),
                            itemCount: 2),
                      )
                    : doc.length == 0
                        ? Container(
                            height: 40,
                            child: Center(
                                child: Text(
                              " NO POSTS",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )))
                        : Expanded(
                            child: RefreshIndicator(
                            onRefresh: beforerefresh,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: doc.length,
                              itemBuilder: (BuildContext context, int index) {
                                // DateTime dt =
                                //     (docs[index]['Createdon'] as Timestamp).toDate();
                                print(doc);
                                return InkWell(
                                    onLongPress: () {
                                      // server.deleteprofile(docs[index]['id']);
                                      // server.readprofile().then((value) {
                                      //   setState(() {
                                      //     docs = value;
                                      //   });
                                      // });
                                    },
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              Duration(milliseconds: 3000),
                                          child: PostBoxProfile(
                                            jobtitle: doc[index]['NeedOf'],
                                            location: doc[index]['Location'],
                                            PhoneNumber: doc[index]
                                                ['PhoneNumber'],
                                            Createdby: doc[index]['Createdby'],
                                            //iscollapsed: isCollapsed,
                                            iscompletedoption: true,
                                            id: doc[index]['id'],
                                            onTaped: () {
                                              print("function working");
                                              loaded = false;
                                              beforerefresh();
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        )
                                      ],
                                    ));
                              },
                            ),
                          )),
                SizedBox(
                  height: 20,
                ),
                // InkWell(
                //   onTap: () {
                //     beforerefresh();
                //     print(docs);
                //   },
                //   child: Container(
                //     child: Text("Refreshh"),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => AddressForm()));
                //   },
                //   child: Container(
                //     child: Text("ADD POST"),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
