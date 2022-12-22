import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FireServer {
  late FirebaseFirestore firestore;
  final _auth = FirebaseAuth.instance;
  initialiase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<List> readprofilefromemail(email) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('profiles')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "Firstname": doc['Firstname'],
            "Lastname": doc['Lastname'],
            'createdon': doc['createdon']
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<String> readprofileidfromemail(email) async {
    QuerySnapshot querySnapshot;
    String profileid = "";
    try {
      querySnapshot = await firestore
          .collection('profiles')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          profileid = doc.id;
        }
        return profileid.toString();
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<List> readprofilepostsfromid(id) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    // try {
    //   querySnapshot = await firestore
    //       .collection('profiles')
    //       .where(FieldPath.documentId, isEqualTo: id)
    //       .get();
    //   if (querySnapshot.docs.isNotEmpty) {
    //     for (var doc in querySnapshot.docs.toList()) {
    //       Map a = {"Posts": doc['Posts']};
    //       docs.add(a);
    //     }
    //     return docs;
    //   }
    try {
      querySnapshot = await firestore
          .collection('profiles')
          .where(FieldPath.documentId, isEqualTo: id)
          .get();

      // Get data from docs and convert map to List
      // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      //for a specific field
      final allData =
          querySnapshot.docs.map((doc) => doc.get('Posts')).toList();
      docs = allData;
      print("All data : $allData");
      return allData;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readprofile() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore.collection('profiles').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "Firstname": doc['Firstname'],
            "Lastname": doc['Lastname'],
            "createdon": doc['createdon']
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readworkerprofiles() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('profiles')
          .where("Profession", isNotEqualTo: "Client")
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "Firstname": doc['Firstname'],
            "Lastname": doc['Lastname'],
            "Profession": doc['Profession'],
            "PhoneNumber": doc['PhoneNumber'],
            "ProfilePic": doc['ProfilePic'],
            "createdon": doc['createdon']
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readprofiledetails(id) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('profiles')
          .where(FieldPath.documentId, whereIn: [id]).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "email": doc['email'],
            "ProfilePic": doc['ProfilePic'],
            "PhoneNumber": doc['PhoneNumber'],
            "Firstname": doc['Firstname'],
            "Lastname": doc['Lastname'],
            "createdon": doc['createdon']
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readposts() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('posts')
          .orderBy('Createdon', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "NeedOf": doc['NeedOf'],
            "Location": doc['Location'],
            "Createdon": doc['Createdon'],
            "PhoneNumber": doc['PhoneNumber'],
            "Createdby": doc['Createdby'],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readpostsbyids(List list) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('posts')
          .where(FieldPath.documentId, whereIn: list)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "NeedOf": doc['NeedOf'],
            "Location": doc['Location'],
            "Createdon": doc['Createdon'],
            "PhoneNumber": doc['PhoneNumber'],
            "Createdby": doc['Createdby']
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<void> createprofile(
      String Firstname, String Lastname, String email, String newid) async {
    try {
      await firestore.collection("profiles").doc(newid).set({
        "Firstname": Firstname,
        "Lastname": Lastname,
        "email": email,
        "Posts": [],
        "ProfilePic": "",
        "PhoneNumber": "",
        "Profession": "",
        "createdon": FieldValue.serverTimestamp()
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addposttoprofile(String id, String profileid) async {
    try {
      Future<void> did =
          firestore.collection("profiles").doc(profileid).update({
        "Posts": FieldValue.arrayUnion([id])
      });
      // await firestore.collection("profiles").add({

      // });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> adddetailstoprofile(String Profession, String Phonenumber,
      String ProfilePic, String profileid) async {
    try {
      Future<void> did =
          firestore.collection("profiles").doc(profileid).update({
        "Profession": Profession,
        "PhoneNumber": Phonenumber,
        "ProfilePic": ProfilePic,
      });
      return true;
      // await firestore.collection("profiles").add({

      // });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatemailtoprofile(String email) async {
    try {
      String profileid = _auth.currentUser!.uid;
      Future<
          void> did = firestore.collection("profiles").doc(profileid).update({
        "email": email,
      }).then((value) => print(
          "its changed in profile too!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!111"));
      // await firestore.collection("profiles").add({

      // });
    } catch (e) {
      print(e);
    }
  }

  Future<void> removepostfromprofile(String id, String profileid) async {
    try {
      Future<void> did =
          firestore.collection("profiles").doc(profileid).update({
        "Posts": FieldValue.arrayRemove([id])
      });
      // await firestore.collection("profiles").add({

      // });
    } catch (e) {
      print(e);
    }
  }

  Future<String> createposts(String Needof, String Location) async {
    initialiase();
    String name = "";
    List docs = await readprofiledetails(_auth.currentUser!.uid);
    name = "${docs[0]['Firstname']} ${docs[0]['Lastname']}";
    String phonenumber = docs[0]['PhoneNumber'];
    try {
      var docref = await firestore.collection("posts").add({
        "Createdon": FieldValue.serverTimestamp(),
        "Location": Location,
        "NeedOf": Needof,
        "Createdby": name,
        "PhoneNumber": phonenumber
      });
      print(docref.id);
      return docref.id;
    } catch (e) {
      print(e);
      return "errorincreateposts";
    }
  }

  Future<void> deleteprofile(String id) async {
    try {
      await firestore.collection("profiles").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteposts(String id) async {
    try {
      await firestore.collection("posts").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
