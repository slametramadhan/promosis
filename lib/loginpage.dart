import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:promosi/adminpage.dart';
import 'package:promosi/mainpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future read() async {
    var response =
        await http.get(Uri.parse('https://queenhaura.my.id/public/api/users'));
    var data = json.decode(response.body)["data"];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var poniSize = MediaQuery.of(context).padding;
    final myBar = AppBar(
      leading: new IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
          icon: Icon(Icons.arrow_back)),
      title: Text('Login Page'),
      backgroundColor: Colors.yellowAccent[400],
    );
    var tinggiLayar =
        screenSize.height - poniSize.top - myBar.preferredSize.height;
    var lebarLayar = screenSize.width;
    DateTime timeBackPressed = DateTime.now();
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
          child: Container(
            child: Form(
              key: _formKey,
              child: Scaffold(
                appBar: myBar,
                body: FutureBuilder(
                    future: read(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        _username.text = 'admin';
                        _password.text = 'admin123';
                        return Container(
                          color: Colors.green[900],
                          height: tinggiLayar,
                          width: lebarLayar,
                          child: Column(
                            children: [
                              Container(
                                child:
                                    Center(child: Image.asset('image/me.png',width: 100,height: 120,)),
                              ),
                              Flexible(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.elliptical(20, 15),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(17.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: tinggiLayar * 0.02,
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return null;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'User Name',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            suffixIcon: Icon(
                                              Icons.people_rounded,
                                              color: Colors.greenAccent[400],
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          controller: _username,
                                        ),
                                        SizedBox(
                                          height: tinggiLayar * 0.02,
                                        ),
                                        TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return null;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Password',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1.5,
                                                    color: Colors.grey),
                                              ),
                                              suffixIcon: Icon(
                                                Icons.lock_outline_rounded,
                                                color: Colors.greenAccent[400],
                                              )),
                                          controller: _password,
                                        ),
                                        SizedBox(
                                          height: tinggiLayar * 0.02,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(lebarLayar,
                                                  tinggiLayar * 0.05),
                                              primary: Colors.greenAccent[700]),
                                          child: Text('Login'),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if ((_username.text ==
                                                      snapshot.data[0]
                                                          ['name']) &&
                                                  (_password.text ==
                                                      snapshot.data[0]
                                                          ['password'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text('Berhasil'),
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ),
                                                );
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminPage(),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text('Tidak Cocok'),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ),
          ),
        ));
  }
}
