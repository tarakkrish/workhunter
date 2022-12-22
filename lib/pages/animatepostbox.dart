import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:workhunter/pages/postbox.dart';

class AnimatePostBox extends StatefulWidget {
  const AnimatePostBox({Key? key}) : super(key: key);

  @override
  State<AnimatePostBox> createState() => _AnimatePostBoxState();
}

class _AnimatePostBoxState extends State<AnimatePostBox> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    dynamic h = MediaQuery.of(context).size.height;
    dynamic w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: 0),
      child: Stack(alignment: Alignment.center, children: [
        AnimatedPositioned(
          height: isExpanded ? 150 : 50,
          width: isExpanded ? w - 40 : w - 100,
          bottom: isExpanded ? 10 : 100,
          duration: const Duration(milliseconds: 500),
          child: Expandeddetails(),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          bottom: isExpanded ? 40 : 20,
          child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: box()),
        ),
      ]),
    );
  }
}

class Expandeddetails extends StatefulWidget {
  const Expandeddetails({Key? key}) : super(key: key);

  @override
  State<Expandeddetails> createState() => _ExpandeddetailsState();
}

class _ExpandeddetailsState extends State<Expandeddetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            "Posted by MR. Rama Krishna",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          )
        ],
      ),
      decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //     begin: Alignment.centerLeft,
          //     end: Alignment.centerRight,
          //     colors: [
          //       Color.fromRGBO(237, 174, 249, 0),
          //       Color.fromRGBO(129, 177, 250, 0)
          //     ]),
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(15))),
    );
  }
}

class box extends StatelessWidget {
  String jobtitle;

  box({Key? key, this.jobtitle = "here"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String jobtitle = "Here";
    String location = "Bhuvaneswar";
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width - 80,
      margin: const EdgeInsets.only(left: 5, right: 5),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _jobtitletext(),
          _payamount(),
          _locationset(),
        ],
      ),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(237, 174, 249, 1),
                Color.fromRGBO(129, 177, 250, 1)
              ]),
          //color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 7, // blur radius
              offset: Offset(0, -2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            )
          ]),
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

  _locationset() {
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
        SizedBox(
            width: 195,
            child: Text(
              jobtitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )
            //overflow: TextOverflow.ellipsis),
            )
      ],
    );
  }

  _jobtitletext() {
    return Container(
      height: 50,
      child: Row(
        children: [
          const ImageIcon(
            AssetImage(
              "assets/workicons/p.jpg",
            ),
            size: 20,
            color: Colors.black,
          ),
          Icon(Icons.format_paint),
          Text(jobtitle,
              style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
