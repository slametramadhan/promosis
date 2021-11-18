// ignore_for_file: unnecessary_statements

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:promosi/loginpage.dart';
import 'package:promosi/promopage.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

final List<String> listgmbr = [];
int time = 0;

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    read();
  }

  Future read() async {
    var response = await http
        .get(Uri.parse('https://queenhaura.my.id/public/api/promosis'));
    var data = json.decode(response.body)["data"];
    return data;
  }

  void _set() {
    if (time == 0) {
      print('this');
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          listgmbr;
        });
        print(listgmbr);
      });
    }
    time = 1;
    print('thos');
  }

  DateTime _dateNow = DateTime.now();

  String _chosenValue = 'Semua';
  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var poniSize = MediaQuery.of(context).padding;
    final myBar = AppBar(
      backgroundColor: Colors.green,
      actions: [
        Container(
          width: 200,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Image.asset(
                        'image/admin.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
      title: Text('Menu'),
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
        child: Scaffold(
          appBar: myBar,
          body: Column(
            children: [
              FutureBuilder(
                  future: read(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (_dateNow.compareTo(DateTime.parse(
                                    snapshot.data[index]['akhirp'])) <
                                0) {
                              listgmbr.add(snapshot.data[index]['gmbrp']);
                            }
                            _set();
                            return Container();
                          });
                    }

                    return Container();
                  }),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 30,
                  child: Text(
                    'Promosi Terbaru',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: Column(
                  children: [
                    Column(
                      children: [
                        CarouselSlider(
                            items: listgmbr
                                .map((item) => Center(
                                      child: Card(
                                        elevation: 5,
                                        child: CachedNetworkImage(
                                          imageUrl: item,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                                autoPlayCurve: Curves.fastOutSlowIn,
                                autoPlay: true,
                                viewportFraction: 0.6,
                                autoPlayAnimationDuration:
                                    const Duration(seconds: 1),
                                enlargeCenterPage: true)),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.elliptical(20, 15),
                            bottomStart: Radius.elliptical(20, 15),
                            topEnd: Radius.elliptical(20, 15),
                            bottomEnd: Radius.elliptical(20, 15),
                          ),
                        ),
                        color: Colors.yellowAccent[100],
                        margin: EdgeInsets.fromLTRB(
                            lebarLayar * 0.1, 0, lebarLayar * 0.1, 0),
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: lebarLayar * 0.3,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _chosenValue,
                                iconEnabledColor: Colors.green[300],
                                items: <String>[
                                  'Mulia',
                                  'Mikro',
                                  'BJDPL',
                                  'Arrum Haji',
                                  'MPO',
                                  'KCA',
                                  'KRASIDA',
                                  'Agen',
                                  'Semua',
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
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                ),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    _chosenValue = newvalue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: tinggiLayar * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.greenAccent[400],
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PromoPage(
                                    pilihan: _chosenValue,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.search_outlined),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
