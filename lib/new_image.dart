import 'dart:convert';
import 'package:impaqt/add_area.dart';
import 'package:impaqt/config/default.dart';
import 'package:impaqt/models/batch_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewImage extends StatefulWidget {
  final image;
  final timeStamp;

  const NewImage({Key key, this.image, this.timeStamp}) : super(key: key);

  @override
  _NewImageState createState() => _NewImageState();
}

class _NewImageState extends State<NewImage> {
  String deger = '';

  var id;

  Future<List<Content>> getAllBarges() async {
    var response;
    try {
      response = await http.get(
          Uri.parse('http://20.52.17.56:8037/api/v1/getAllBarge'),
          headers: {'Content-Type': 'application/json'});
      var jsonData = await json.decode(response.body);
        setState(() {
          allBarges = BatchModel.fromJson(jsonData).content;
        });
      return allBarges;
    } catch (e) {
      print('get all barges hatalı ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getAllBarges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Image.file(
                  widget.image,
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('Choose Folder'),
                          items: allBarges
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e.id,
                                ),
                              )
                              .toList(),
                          value: id,
                          onChanged: (value) {
                            setState(() {
                              id = value;
                              deger = allBarges[id - 1].name;
                              print(deger);
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AddArea()))
                              .then((value) {
                            getAllBarges().then((value) {
                              id = value.last.id;
                              deger = value.last.name;
                            });
                            setState(() {
                              print(value);
                            });
                          });
                        },
                        child: Text('Add Folder'),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff200371)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Your File => ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text(
                        deger + '_${widget.timeStamp}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                /*
                                TextForm(
                  onSaved: (value){
                    _text = value;
                  },
                  hintText: '${deger}_1626074840',
                  validator: (value){
                    if(value.isNotEmpty){
                      return 'Not Empty';
                    }
                  },
                )
                 */
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff7adac0)),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'New Photo',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff009688)),
                        onPressed: () {
                          if (id != null) {
                            Navigator.of(context)
                                .pop(deger + '_${widget.timeStamp}');
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text('Please choose a folder'),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                'Send',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.arrow_forward_sharp)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
