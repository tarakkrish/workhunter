import 'package:flutter/material.dart';
import 'package:workhunter/data/location.dart';
import 'package:workhunter/pages/HomePage.dart';
import 'package:workhunter/pages/addressform.dart';
import 'package:workhunter/pages/animatepostbox.dart';
import 'package:workhunter/pages/changemailpage.dart';
import 'package:workhunter/pages/homescreen.dart';
import 'package:workhunter/pages/inputform.dart';
import 'package:workhunter/pages/loginpage.dart';
import 'package:workhunter/pages/menudashboard.dart';
import 'package:workhunter/pages/otpveritfication.dart';
import 'package:workhunter/pages/profilepage.dart';
import 'package:workhunter/pages/signuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workhunter/pages/signuppage2.dart';
import 'package:workhunter/pages/walkinpage.dart';
import 'package:workhunter/pages/welcomepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  //TextEditingController emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //emailcontroller.text = "krishnarockstar36143@gmail.com";
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.white),
        debugShowCheckedModeBanner: false,
        //home: InitialWidget(),
        //home: Loginui(),
        home: WelcomePage(),
        //home: ChangeEmail()
        //home: HomePage(),
        //home: MenuDashboardPage(),
        //home: SignUp(),
        //home: OtpVerificationPage()
        // home: Emailotpverification(
        //     emailcontroller: emailcontroller,
        //     Firstname: "Fir",
        //     Lastname: "Lasy",
        //     password: "123454365"),
        //home: Signup2(Firstname: "Fir", Lastname: "Lasy", password: "123454365"),
        //home: ProfilePage(),
        routes: {
          'LoginPage': (context) => LoginPage(),
          'HelloPage': (context) => WalkInPage(),
          'InitialPage': (context) => InitialWidget(),
        });
  }
}

class InitialWidget extends StatefulWidget {
  const InitialWidget({Key? key}) : super(key: key);

  @override
  _InitialWidgetState createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  late FirebaseAuth _auth;
  late User? _user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    //print(_user!.phoneNumber);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? WalkInPage()
            : MenuDashboardPage();
  }
}
