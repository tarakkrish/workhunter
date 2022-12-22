import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:workhunter/data/city_data.dart';

class InputForm extends StatefulWidget {
  const InputForm({Key? key}) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  String requirementjob = "";
  final formkey = GlobalKey<FormState>();
  final _currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];
  final controllerCity = TextEditingController();
  final controllerjob = TextEditingController();
  String _currentSelectedValue = '';
  String? selectedCity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Column(
              children: [
                Form(
                    key: formkey,
                    child: Expanded(
                        child: ListView(
                      children: [jobfield(), buildcity()],
                    )))
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget buildcity() => TypeAheadFormField<String?>(
        textFieldConfiguration: TextFieldConfiguration(
            controller: controllerCity,
            decoration: InputDecoration(
                labelText: "City", border: OutlineInputBorder())),
        suggestionsCallback: CityData.getSuggestions,
        itemBuilder: (context, String? suggestion) => ListTile(
          title: Text(suggestion!),
        ),
        onSuggestionSelected: (String? suggestion) =>
            controllerCity.text = suggestion!,
        validator: (value) =>
            value != null && value.isEmpty ? 'Please select a City' : null,
        onSaved: (value) => selectedCity = value,
      );

  Widget jobfield() => TextFormField(
        decoration: const InputDecoration(
          labelText: "Enter Reqiurement of Job",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Select value from list';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() {
          requirementjob = value.toString();
        }),
      );
}

textStyle() {
  return const TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
}
