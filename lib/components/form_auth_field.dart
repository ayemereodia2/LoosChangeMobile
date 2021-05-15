import 'package:flutter/material.dart';

class FormAuthField extends StatelessWidget {

  final TextEditingController controller;
  final String customhinttext;
  final IconData customicon;
  final TextInputAction customtextinputaction;
  final TextInputType customkeyboardinputtype;
  final bool customobstextvalue;
  final String initialValue;
  final Function onChanged;
  final AutovalidateMode autovalidateMode;
  final Function validator;

  const FormAuthField({
    this.controller,
    @required this.customhinttext,
    this.customicon,
    @required this.customtextinputaction,
    this.customkeyboardinputtype,
    this.customobstextvalue = false,
    this.initialValue,
    this.onChanged,
    this.autovalidateMode,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: initialValue,
        validator: validator,
        controller: controller,
        obscureText: customobstextvalue,
        autovalidateMode: autovalidateMode,
        textInputAction: customtextinputaction,
        style: TextStyle(
          color: Colors.black,
        ),
        keyboardType: customkeyboardinputtype,
        decoration: InputDecoration(
          icon: Icon(
            customicon,
            color: Colors.blueGrey,
          ),
          hintText: customhinttext,
          hintStyle: TextStyle(
            color: Colors.black,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightGreen,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
