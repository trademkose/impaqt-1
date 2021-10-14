import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final onSaved;
  final validator;
  final hintText;

  TextForm({Key key, this.onSaved, this.validator, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
