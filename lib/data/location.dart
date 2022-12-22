import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// abstract class Mess {
//   void func() async {
//     var addw = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addw.first;
//     print("${first.featureName} : ${first.addressLine}");
//   }
// }

// class Second extends Mess {
//   void func();
// }

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String address = " not performed";
  String address1 = "";
  String address2 = "";
  String finalAdddress = "";

  @override
  void initState() {
    super.initState();
    locations();
  }

  Future<Future> locations() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      LocationPermission permissions = await Geolocator.requestPermission();
      locations();
    }

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

  Future GetAddressFromlatlon(Position position) async {
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

  bool locpermsn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: Text(address),
            ),
            Text(" addresss : $address1"),
            Text("final address: $finalAdddress")
          ],
        ),
      ),
    );
  }
}
