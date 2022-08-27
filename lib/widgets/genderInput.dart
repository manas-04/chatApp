// ignore_for_file: file_names

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class GenderInput extends StatelessWidget {
  const GenderInput({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, String?> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 3),
      child: DropDownTextField(
        initialValue: data['gender'],
        textFieldDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: 'Gender',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          hintText: "Gender",
        ),
        // singleController: _cnt,
        clearOption: true,
        validator: (value) {
          if (value == null) {
            return "Required field";
          } else {
            return null;
          }
        },
        dropDownItemCount: 3,
        dropDownList: const [
          DropDownValueModel(name: 'Male', value: "Male"),
          DropDownValueModel(
            name: 'Female',
            value: "Female",
          ),
          DropDownValueModel(name: 'Others', value: "Others"),
        ],
        onChanged: (val) {
          if (val != "") {
            data['gender'] = val.value;
          } else {
            data['gender'] = "";
          }
        },
      ),
    );
  }
}
