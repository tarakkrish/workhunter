import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:workhunter/data/helper.dart';

class VerifyEmailPage extends StatefulWidget {
  final TextEditingController emailcontroller;
  final TextEditingController passwordController;
  const VerifyEmailPage(
      {Key? key,
      required this.passwordController,
      required this.emailcontroller})
      : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Service service = Service();
  TextEditingController _otpcontroller = TextEditingController();
  late EmailAuth emailAuth;
  bool submitValid = false;
  @override
  void initState() {
    super.initState();
    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );
    sendOtp();

    /// Configuring the remote server
    //emailAuth.config(remoteServerConfiguration);
  }

  Future<void> sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: widget.emailcontroller.value.text, otpLength: 5);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }

  void verify() {
    bool d = emailAuth.validateOtp(
        recipientMail: widget.emailcontroller.value.text,
        userOtp: _otpcontroller.value.text);
    print(d);
    if (d == true) {
      service.createUser(
          widget.emailcontroller.text, widget.passwordController.text, context);
      print("account created ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          TextField(
            controller: _otpcontroller,
          ),
          ElevatedButton(
            child: Text("validate"),
            onPressed: () {
              verify();
            },
          )
        ],
      ),
    ));
  }
}

class Verifyemail {
  EmailAuth emailAuth = new EmailAuth(
    sessionName: "Work Hunter",
  );
  bool verify(email, otp) {
    bool d = emailAuth.validateOtp(recipientMail: email, userOtp: otp);
    print(d);
    if (d == true) {
      // service.createUser(
      //     widget.emailcontroller.text, widget.passwordController.text, context);
      // print("account created ");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendOtp(email) async {
    bool result = await emailAuth.sendOtp(recipientMail: email, otpLength: 5);
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}
