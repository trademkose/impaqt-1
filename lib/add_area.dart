import 'dart:convert';
import 'package:impaqt/config/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddArea extends StatefulWidget {
  const AddArea({Key key}) : super(key: key);

  @override
  _AddAreaState createState() => _AddAreaState();
}

class _AddAreaState extends State<AddArea> {
  final _formKey = GlobalKey<FormState>();
  String _area;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Folder Part'),backgroundColor: Color(0xff009688),),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Folder',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 15,),
                TextForm(
                  onSaved: (value){
                    _area = value;
                  },
                  hintText: 'Enter folder name',
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(style: ElevatedButton.styleFrom(primary: Color(0xff009688)),onPressed: () async {
                        _formKey.currentState.save();
                        var msg = {
                          'name':_area,
                          'description':'test'
                        };
                        var response = await http.post(Uri.parse('http://20.52.17.56:8037/api/v1/addBarge'),headers: {
                          'Content-Type':'application/json'
                        },body: json.encode(msg));
                        Navigator.of(context).pop(_area);
                      }, child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Save',style: TextStyle(fontSize: 20),),
                            SizedBox(width: 10,),
                            Icon(Icons.arrow_forward_sharp)
                          ],
                        ),
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
