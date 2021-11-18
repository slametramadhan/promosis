import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:promosi/adminpage.dart';
import 'dart:convert';

class TambahPage extends StatefulWidget {
  const TambahPage({Key? key}) : super(key: key);

  @override
  _TambahPageState createState() => _TambahPageState();
}

void initState() {
  print('object');
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDateAwal = DateTime.now();
  DateTime _selectedDateAkhir = DateTime.now();
  String _chosenValue = 'Mulia';
  String _chosenValue1 = 'Area';
  String _chosenValue2 = 'Konven';
  TextEditingController _namapCon = TextEditingController();
  TextEditingController _jenispCon = TextEditingController();
  TextEditingController _idpCon = TextEditingController();
  TextEditingController _asalpCon = TextEditingController();
  TextEditingController _untukpCon = TextEditingController();
  TextEditingController _mulaipCon = TextEditingController();
  TextEditingController _akhirpCon = TextEditingController();
  TextEditingController _gmbrpCon = TextEditingController();
  TextEditingController _pdfpCon = TextEditingController();
  DateTime timeBackPressed = DateTime.now();
  var status = 'No';

  Future save() async {
    var response = await http
        .post(Uri.parse('https://queenhaura.my.id/public/api/promosis'), body: {
      "namap": _namapCon.text,
      "jenisp": _chosenValue,
      "idp": _idpCon.text,
      "asalp": _chosenValue1,
      "untukp": _chosenValue2,
      "mulaip": _mulaipCon.text,
      "akhirp": _akhirpCon.text,
      "gmbrp": 'https://drive.google.com/uc?export=view&id=${_gmbrpCon.text}',
      "pdfp": _pdfpCon.text,
    });
    var data = json.decode(response.body)["data"];
    return data;
  }

  void _pickDateDialogAwal() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2025),
            initialEntryMode: DatePickerEntryMode.input)
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDateAwal = pickedDate;
        _mulaipCon.text =
            '${DateFormat('yyyy-MM-dd').format(_selectedDateAwal)}';
      });
    });
  }

  void _pickDateDialogAkhir() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2025),
            initialEntryMode: DatePickerEntryMode.input)
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDateAkhir = pickedDate;
        _akhirpCon.text =
            '${DateFormat('yyyy-MM-dd').format(_selectedDateAkhir)}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var poniSize = MediaQuery.of(context).padding;
    final myBar = AppBar(
      leading: new IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AdminPage()));
          },
          icon: Icon(Icons.arrow_back)),
      title: Text('Tambah Promosi'),
      backgroundColor: Colors.yellowAccent[400],
    );

    var tinggiLayar =
        screenSize.height - poniSize.top - myBar.preferredSize.height;
    var lebarLayar = screenSize.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= Duration(seconds: 2);
          timeBackPressed = DateTime.now();
          if (isExitWarning) {
            print(screenSize.height);

            final message = 'Tekan 2x untuk keluar';
            Fluttertoast.showToast(msg: message, fontSize: 18);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Form(
          key: _formKey,
          child: Scaffold(
            appBar: myBar,
            body: Container(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Wrap(
                      runSpacing: 10,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Nama Promosi',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.5, color: Colors.grey),
                              ),
                              suffixIcon: Icon(
                                Icons.contact_page,
                                color: Colors.greenAccent[400],
                              )),
                          controller: _namapCon,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _chosenValue,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),

                              items: <String>[
                                'Mulia',
                                'Mikro',
                                'BJDPL',
                                'Arrum Haji',
                                'MPO',
                                'KCA',
                                'KRASIDA',
                                'Agen',
                                'Lain-lain'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              elevation: 8,
                              icon: Icon(Icons.arrow_drop_down),

                              isExpanded: true,
                              onChanged: (String? newvalue) {
                                setState(() {
                                  _chosenValue = newvalue!;
                                  print(_chosenValue);
                                });
                              },
                            ),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Id Promosi',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.5, color: Colors.grey),
                              ),
                              suffixIcon: Icon(
                                Icons.wb_iridescent,
                                color: Colors.greenAccent[400],
                              )),
                          controller: _idpCon,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _chosenValue1,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),

                              items: <String>[
                                'Area',
                                'Kanwil',
                                'Pusat',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),

                              elevation: 8,
                              icon: Icon(Icons.arrow_drop_down),

                              isExpanded: true,
                              onChanged: (String? newvalue) {
                                setState(() {
                                  _chosenValue1 = newvalue!;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _chosenValue2,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),

                              items: <String>[
                                'Konven',
                                'Syariah',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              elevation: 8,
                              icon: Icon(Icons.arrow_drop_down),

                              isExpanded: true,
                              onChanged: (String? newvalue) {
                                setState(() {
                                  _chosenValue2 = newvalue!;
                                });
                              },
                            ),
                          ),
                        ),
                        TextField(
                          controller: _mulaipCon,
                          decoration: InputDecoration(
                            labelText: 'Mulai Promosi',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.grey),
                            ),
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.arrow_drop_down),
                              onTap: () {
                                _pickDateDialogAwal();
                              },
                            ),
                          ),
                        ),
                        TextField(
                          controller: _akhirpCon,
                          decoration: InputDecoration(
                            labelText: 'Akhir Promosi',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.grey),
                            ),
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.arrow_drop_down),
                              onTap: () {
                                _pickDateDialogAkhir();
                              },
                            ),
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Gambar',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.5, color: Colors.grey),
                              ),
                              suffixIcon: Icon(
                                Icons.emoji_objects_sharp,
                                color: Colors.greenAccent[400],
                              )),
                          controller: _gmbrpCon,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'PDF',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.5, color: Colors.grey),
                              ),
                              suffixIcon: Icon(
                                Icons.picture_as_pdf_rounded,
                                color: Colors.greenAccent[400],
                              )),
                          controller: _pdfpCon,
                        ),
                        ElevatedButton(
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(lebarLayar, tinggiLayar * 0.05),
                              primary: Colors.greenAccent[700]),
                          onPressed: () {
                            cek();
                            print(status);
                            if (status == 'Ok') {
                              save().then(
                                (value) {
                                  clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Berhasil ditambah'),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminPage(),
                                    ),
                                  );
                                },
                                onError: (value) {
                                  CircularProgressIndicator();
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    _namapCon.text = '';
    _jenispCon.text = '';
    _idpCon.text = '';
    _asalpCon.text = '';
    _untukpCon.text = '';
    _mulaipCon.text = '';
    _akhirpCon.text = '';
    _gmbrpCon.text = '';
    _pdfpCon.text = '';
  }

  void cek() {
    if (_namapCon.text != '' ||
        _jenispCon.text != '' ||
        _idpCon.text != '' ||
        _asalpCon.text != '' ||
        _untukpCon.text != '' ||
        _mulaipCon.text != '' ||
        _akhirpCon.text != '' ||
        _gmbrpCon.text != '' ||
        _pdfpCon.text != '') {
      status = 'Ok';
    } else {
      status = 'No';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),behavior: SnackBarBehavior.floating,
          content: Text('Field Kosong'),
        ),
      );
    }
  }
}
