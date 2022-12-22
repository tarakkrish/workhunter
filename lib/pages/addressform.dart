import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workhunter/colors/colorsofpage.dart';
import 'package:workhunter/data/fireserver.dart';
import 'package:workhunter/data/helper.dart';
import 'package:workhunter/data/location.dart';
import 'package:workhunter/pages/inputform.dart';
import 'package:workhunter/pages/menudashboard.dart';
import 'package:workhunter/pages/profilepage.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key}) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  TextEditingController addresscontroller = new TextEditingController();
  TextEditingController workcontroller = new TextEditingController();
  bool uselocation = false;
  String address = " not performed";
  String address1 = "";
  String address2 = "";
  String finalAdddress = "";
  String typedaddress = "";
  String profileid = ""; // before clicking gps option

  @override
  void initState() {
    super.initState();
    fireserver.initialiase();
    locations();
  }

  proid() {
    if (_auth.currentUser != null) {
      String email = _auth.currentUser!.email!;
      //String email = "vamsirockstar36143@gmail.com";
      fireserver.readprofileidfromemail(email).then((value) {
        setState(() {
          profileid = value;
          print(profileid);
        });
      });
      return profileid;
    }
  }

  locations() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      LocationPermission permissions = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        address =
            " Latitude ${position.latitude} , longitude ${position.longitude}";
      });

      // final coordinates = Coordinates(position.latitude, position.longitude);
      // var add = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // setState(() {
      //   address2 = add.first.addressLine;
      //   address1 = add.first.featureName;
      // });
      print(permission);
      return GetAddressFromlatlon(position);
    }
  }

  Future<String> GetAddressFromlatlon(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      finalAdddress =
          '${place.street} ,${place.thoroughfare} , ${place.subLocality}, ${place.locality} - ${place.postalCode}, ${place.administrativeArea} , ${place.country}';
      address1 =
          ' administrative area ${place.administrativeArea},subadmin ${place.subAdministrativeArea},${place.subThoroughfare},${place.thoroughfare} street ${place.street} sublocality ${place.subLocality},locality ${place.locality},postalcode ${place.postalCode}, ${place.country}';
    });
    return finalAdddress;
  }

  Service service = Service();
  FireServer fireserver = FireServer();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     body: SafeArea(
    //         child: Container(
    //   child: Column(
    //     children: [
    //       Text("fill address"),
    //       Row(
    //         children: [
    //           Text("use your location"),
    //           Checkbox(
    //               value: uselocation,
    //               onChanged: (bool? value) {
    //                 setState(() {
    //                   uselocation = !uselocation;
    //                   if (uselocation == true) {
    //                     locations();
    //                     typedaddress = addresscontroller.text;
    //                     addresscontroller.text = finalAdddress;
    //                   } else {
    //                     addresscontroller.text = typedaddress;
    //                   }
    //                 });
    //               }),
    //         ],
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Text("Address"),
    //       TextFormField(
    //         maxLines: 5,
    //         controller: addresscontroller,
    //       )
    //     ],
    //   ),
    // )));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsoflogin().backtop,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          "Add Post",
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontFamily: 'Buckin'),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 150,
            padding:
                const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 25),
            child: Column(
              children: [
                _inputbox("Need of Work", workcontroller, 55.0, 1),
                const SizedBox(
                  height: 20,
                ),
                _inputbox("Address", addresscontroller, 150.0, 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                        value: uselocation,
                        onChanged: (bool? value) {
                          setState(() {
                            uselocation = !uselocation;
                            if (uselocation == true) {
                              locations();
                              typedaddress = addresscontroller.text;
                              addresscontroller.text = finalAdddress;
                            } else {
                              addresscontroller.text = typedaddress;
                            }
                          });
                        }),
                    const Text("use your location"),
                  ],
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    ontappost();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: const Text("ADD POST"),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorsoflogin().loginbutton1,
                              colorsoflogin().loginbutton2
                            ])),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _inputbox(title, TextEditingController controller, double height, int max) {
    return Container(
        //margin: const EdgeInsets.all(20),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, color: Colors.black87, fontFamily: 'Buckin'),
        ),
        Container(
          height: height,
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.only(
            left: 14,
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TextFormField(
                minLines: 1,
                maxLines: max,
                autofocus: false,
                cursorColor: Colors.white,
                controller: controller,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, fontFamily: 'Buckin'),
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0)),
                ),
              )),
            ],
          ),
        )
      ],
    ));
  }

  ontappost() async {
    if (workcontroller.text.isEmpty || addresscontroller.text.isEmpty) {
      print("Fields can't be empty");
    } else {
      List checkdocs = [];
      await fireserver.readprofiledetails(_auth.currentUser!.uid).then((value) {
        checkdocs = value;
      });
      if (checkdocs[0]['PhoneNumber'] == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Complete Profile to Add post")));
      } else {
        String id = await fireserver.createposts(
            workcontroller.text, addresscontroller.text);

        // Future<String> profileid = fireserver
        //     .readprofileidfromemail(proid());
        fireserver.addposttoprofile(id, _auth.currentUser!.uid);
        print("d: response of createposts : $id");
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => MenuDashboardPage())));
      }
    }
  }
}
