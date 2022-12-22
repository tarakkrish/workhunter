import 'package:flutter/material.dart';
import 'package:workhunter/pages/animatepostbox.dart';
import 'package:workhunter/pages/postbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return const MobileHomepage();
        } else {
          return const DesktopHomepage();
        }
      },
    );
  }
}

class MobileHomepage extends StatefulWidget {
  const MobileHomepage({Key? key}) : super(key: key);

  @override
  _MobileHomepageState createState() => _MobileHomepageState();
}

class _MobileHomepageState extends State<MobileHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostBox(
                    location: "Delhi,125255",
                    jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh",
                    iscompletedoption: true,
                    PhoneNumber: "+917658122412225",
                    Createdby: "Rama Krishna",
                  ),
                  PostBox(
                    location: "Delhi,125255",
                    jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh",
                    iscompletedoption: false,
                    PhoneNumber: "+917658122412225",
                    Createdby: "Rama Krishna",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PostBox(
                    location: "Delhi,125255",
                    jobtitle: "Engineer",
                    PhoneNumber: "+917658122412225",
                    Createdby: "Rama Krishna",
                  ),
                  Container(
                    height: 200,
                    child: AnimatePostBox(),
                  ),
                  Container(height: 225, child: AnimatePostBox()),
                  Container(height: 225, child: AnimatePostBox()),
                  Container(height: 225, child: AnimatePostBox()),
                  Container(height: 225, child: AnimatePostBox())
                ],
              ),
            ),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color.fromRGBO(237, 174, 249, 1),
                  Color.fromRGBO(129, 177, 250, 1)
                ]))),
      ),
    );
  }
}

class DesktopHomepage extends StatefulWidget {
  const DesktopHomepage({Key? key}) : super(key: key);

  @override
  _DesktopHomepageState createState() => _DesktopHomepageState();
}

class _DesktopHomepageState extends State<DesktopHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Wrap(
          runAlignment: WrapAlignment.center,
          children: [
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
            // PostBox(
            //     location: "Delhi,125255",
            //     jobtitle: "Engineerin ggdfsdf gdfg dfghfgdf dfhdfh"),
            // const SizedBox(
            //   height: 20,
            // ),
            // PostBox(location: "Delhi,125255", jobtitle: "Engineer"),
          ],
        ),
      )),
    );
  }
}
