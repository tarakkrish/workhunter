import 'package:workhunter/pages/otpveritfication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello Janne",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 15),
              Text(
                "Categories",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: FutureBuilder(
                          future: _getImage(context, "icon-6.png"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Container(
                                /*decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.asset("assets/feather-heart.png"))*/
                                child: Image.network("${snapshot.data}"),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                      Text(
                        "name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _auth.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OtpVerificationPage()));
        },
        child: Icon(Icons.logout),
      ),
    );
  }

  /* _categorybox(String imageaddress, title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: FutureBuilder(
            future: _getImage(context, imageaddress),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.network("$imageaddress"))),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
        )
      ],
    );
  }*/

  Future<String> _getImage(BuildContext context, String imageName) async {
    String image = "assets/images/feather-heart.png";
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = value.toString();
    });
    return image;
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String Image) {
    return FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
