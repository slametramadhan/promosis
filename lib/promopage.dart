import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'mainpage.dart';

class PromoPage extends StatefulWidget {
  final String pilihan;
  PromoPage({Key? key, required this.pilihan}) : super(key: key);

  @override
  _PromoPageState createState() => _PromoPageState();
}

final String url = 'https://queenhaura.my.id/public/api/promosis';

Future read() async {
  var response = await http.get(Uri.parse(url));
  var data = json.decode(response.body)["data"];
  return data;
}

Future readabc() async {
  var response = await http
      .get(Uri.parse('https://queenhaura.my.id/public/api/promosis/abc'));
  var data = json.decode(response.body)["data"];
  return data;
}

Future readjenis() async {
  var response = await http
      .get(Uri.parse('https://queenhaura.my.id/public/api/promosis/jenis'));
  var data = json.decode(response.body)["data"];
  return data;
}

Future readuntuk() async {
  var response = await http
      .get(Uri.parse('https://queenhaura.my.id/public/api/promosis/untuk'));
  var data = json.decode(response.body)["data"];

  return data;
}

Future readexpired() async {
  var response = await http
      .get(Uri.parse('https://queenhaura.my.id/public/api/promosis/expired'));
  var data = json.decode(response.body)["data"];
  return data;
}

void _launchURL(_url) async => await launch(_url);
var x = read();

Color _expiredColor = Colors.black;
Color _aktifColor1=Colors.transparent;
Color _aktifColor2=Colors.transparent;
Color _aktifColor3=Colors.transparent;
Color _aktifColor4=Colors.transparent;

var indicators = 0;
DateTime _dateNow = DateTime.now();
String formattedDate = DateFormat('yyyy-MM-dd').format(_dateNow);
var _expired = '';

class _PromoPageState extends State<PromoPage> {
  @override
  void initState() {
    super.initState();
    x = read();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var poniSize = MediaQuery.of(context).padding;
    final myBar = AppBar(
      leading: new IconButton(
          onPressed: () {
            setState(() {
              _expiredColor = Colors.black;
              _expired = '';

              colorubah(0);
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
          icon: Icon(Icons.arrow_back)),
      actions: [
        Container(
          width: 200,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    colorubah(1);
                    x = readabc();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Urut Huruf'),
                        duration: Duration(seconds: 1)));
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _aktifColor1, width: 2)),
                      child: Image.asset(
                        'image/Abc.png',
                        width: 20,
                        height: 20,
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    colorubah(2);
                    x = readuntuk();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Urut Untuk'),
                        duration: Duration(seconds: 1)));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _aktifColor2, width: 2)),
                      child:
                          Image.asset('image/goal.png', width: 20, height: 20)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    colorubah(3);
                    x = readjenis();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Urut Jenis'),
                        duration: Duration(seconds: 1)));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                     decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _aktifColor3,width: 2)
                      ),
                    child: Image.asset(
                      'image/asal.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    colorubah(4);
                    x = readexpired();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Urut Tanggal Expired'),
                        duration: Duration(seconds: 1)));
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                     decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _aktifColor4,width: 2)
                      ),
                    child: Image.asset(
                      'image/exp.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
      title: AutoSizeText(
        'Promosi #${widget.pilihan}',
        softWrap: true,
        maxLines: 1,
      ),
      backgroundColor: Colors.green,
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
        child: Scaffold(
          appBar: myBar,
          floatingActionButton: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.cyan[300],
            child: Icon(Icons.low_priority_sharp),
            onPressed: () {
              _expired = 'ada';
              setState(() {
                x = read();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tampilkan Promo Expired Berhasil'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          body: Container(
            child: FutureBuilder(
              future: x,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (widget.pilihan == 'Semua') {
                          if (_expired != 'ada') {
                            if (_dateNow.compareTo(DateTime.parse(
                                    snapshot.data[index]['akhirp'])) <
                                0) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Container(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        bottomStart: Radius.elliptical(20, 15),
                                        bottomEnd: Radius.elliptical(20, 15),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                        lebarLayar * 0.02,
                                        0,
                                        lebarLayar * 0.02,
                                        0),
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Card(
                                          color: Colors.greenAccent[400],
                                          elevation: 5,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  width: lebarLayar * 0.7,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    snapshot.data[index]
                                                        ['namap'],
                                                    softWrap: true,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 10, 0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons
                                                            .picture_as_pdf_rounded,
                                                        size: 30,
                                                        color: Colors
                                                            .redAccent[100],
                                                      ),
                                                      onTap: () {
                                                        _launchURL(
                                                          snapshot.data[index]
                                                              ['pdfp'],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .only(
                                                        bottomStart:
                                                            Radius.elliptical(
                                                                20, 15),
                                                        bottomEnd:
                                                            Radius.elliptical(
                                                                20, 15),
                                                      ),
                                                    ),
                                                    elevation: 5,
                                                    child: Container(
                                                      height:
                                                          tinggiLayar * 0.17,
                                                      width: lebarLayar * 0.25,
                                                      alignment:
                                                          Alignment.center,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _launchURL(snapshot
                                                                  .data[index]
                                                              ['gmbrp']);
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          height: tinggiLayar *
                                                              0.13,
                                                          width:
                                                              lebarLayar * 0.2,
                                                          imageUrl: snapshot
                                                                  .data[index]
                                                              ['gmbrp'],
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .data_usage,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Jenis'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(snapshot
                                                                            .data[
                                                                        index]
                                                                    ['jenisp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .format_list_numbered,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Nomor ID'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'idp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .where_to_vote_sharp,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Asal'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(snapshot
                                                                            .data[
                                                                        index]
                                                                    ['asalp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .golf_course_sharp,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Untuk'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(snapshot
                                                                            .data[
                                                                        index]
                                                                    ['untukp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .explicit_outlined,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Expired'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'akhirp'],
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 1,
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
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else {
                            _expiredColor = Colors.black;
                            if (_dateNow.compareTo(DateTime.parse(
                                    snapshot.data[index]['akhirp'])) >
                                0) {
                              _expiredColor = Colors.red;
                            }

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomStart: Radius.elliptical(20, 15),
                                      bottomEnd: Radius.elliptical(20, 15),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(lebarLayar * 0.02,
                                      0, lebarLayar * 0.02, 0),
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Card(
                                        color: Colors.greenAccent[400],
                                        elevation: 5,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                width: lebarLayar * 0.7,
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText(
                                                  snapshot.data[index]['namap'],
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 10, 0),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    child: Icon(
                                                      Icons
                                                          .picture_as_pdf_rounded,
                                                      size: 30,
                                                      color:
                                                          Colors.redAccent[100],
                                                    ),
                                                    onTap: () {
                                                      _launchURL(
                                                        snapshot.data[index]
                                                            ['pdfp'],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .only(
                                                      bottomStart:
                                                          Radius.elliptical(
                                                              20, 15),
                                                      bottomEnd:
                                                          Radius.elliptical(
                                                              20, 15),
                                                    ),
                                                  ),
                                                  elevation: 5,
                                                  child: Container(
                                                    height: tinggiLayar * 0.17,
                                                    width: lebarLayar * 0.25,
                                                    alignment: Alignment.center,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _launchURL(
                                                            snapshot.data[index]
                                                                ['gmbrp']);
                                                      },
                                                      child: CachedNetworkImage(
                                                        height:
                                                            tinggiLayar * 0.13,
                                                        width: lebarLayar * 0.2,
                                                        imageUrl:
                                                            snapshot.data[index]
                                                                ['gmbrp'],
                                                        progressIndicatorBuilder: (context,
                                                                url,
                                                                downloadProgress) =>
                                                            CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .data_usage,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Text('Jenis'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'jenisp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .format_list_numbered,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'Nomor ID'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      ['idp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .where_to_vote_sharp,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Text('Asal'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'asalp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .golf_course_sharp,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Text('Untuk'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'untukp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .explicit_outlined,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'Expired'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  AutoSizeText(
                                                                snapshot.data[
                                                                        index]
                                                                    ['akhirp'],
                                                                style: TextStyle(
                                                                    color:
                                                                        _expiredColor),
                                                                softWrap: true,
                                                                maxLines: 1,
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
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        if (widget.pilihan == snapshot.data[index]['jenisp']) {
                          if (_expired != 'ada') {
                            if (_dateNow.compareTo(DateTime.parse(
                                    snapshot.data[index]['akhirp'])) <
                                0) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Container(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        bottomStart: Radius.elliptical(20, 15),
                                        bottomEnd: Radius.elliptical(20, 15),
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(
                                        lebarLayar * 0.02,
                                        0,
                                        lebarLayar * 0.02,
                                        0),
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Card(
                                          color: Colors.greenAccent[400],
                                          elevation: 5,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  width: lebarLayar * 0.7,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    snapshot.data[index]
                                                        ['namap'],
                                                    softWrap: true,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 10, 0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: GestureDetector(
                                                      child: Icon(
                                                        Icons
                                                            .picture_as_pdf_rounded,
                                                        size: 30,
                                                        color: Colors
                                                            .redAccent[100],
                                                      ),
                                                      onTap: () {
                                                        _launchURL(
                                                          snapshot.data[index]
                                                              ['pdfp'],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .only(
                                                        bottomStart:
                                                            Radius.elliptical(
                                                                20, 15),
                                                        bottomEnd:
                                                            Radius.elliptical(
                                                                20, 15),
                                                      ),
                                                    ),
                                                    elevation: 5,
                                                    child: Container(
                                                      height:
                                                          tinggiLayar * 0.17,
                                                      width: lebarLayar * 0.25,
                                                      alignment:
                                                          Alignment.center,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _launchURL(snapshot
                                                                  .data[index]
                                                              ['gmbrp']);
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          height: tinggiLayar *
                                                              0.13,
                                                          width:
                                                              lebarLayar * 0.2,
                                                          imageUrl: snapshot
                                                                  .data[index]
                                                              ['gmbrp'],
                                                          progressIndicatorBuilder: (context,
                                                                  url,
                                                                  downloadProgress) =>
                                                              CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .data_usage,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Jenis'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(snapshot
                                                                            .data[
                                                                        index]
                                                                    ['jenisp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .format_list_numbered,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Nomor ID'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'idp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .where_to_vote_sharp,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Asal'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(snapshot
                                                                            .data[
                                                                        index]
                                                                    ['asalp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .golf_course_sharp,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Untuk'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(snapshot
                                                                            .data[
                                                                        index]
                                                                    ['untukp']),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5, 0, 5, 0),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .explicit_outlined,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Expired'),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    AutoSizeText(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'akhirp'],
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 1,
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
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          } else {
                            _expiredColor = Colors.black;
                            if (_dateNow.compareTo(DateTime.parse(
                                    snapshot.data[index]['akhirp'])) >
                                0) {
                              _expiredColor = Colors.red;
                            }
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomStart: Radius.elliptical(20, 15),
                                      bottomEnd: Radius.elliptical(20, 15),
                                    ),
                                  ),
                                  margin: EdgeInsets.fromLTRB(lebarLayar * 0.02,
                                      0, lebarLayar * 0.02, 0),
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Card(
                                        color: Colors.greenAccent[400],
                                        elevation: 5,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                width: lebarLayar * 0.7,
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText(
                                                  snapshot.data[index]['namap'],
                                                  softWrap: true,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 10, 0),
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    child: Icon(
                                                      Icons
                                                          .picture_as_pdf_rounded,
                                                      size: 30,
                                                      color:
                                                          Colors.redAccent[100],
                                                    ),
                                                    onTap: () {
                                                      _launchURL(
                                                        snapshot.data[index]
                                                            ['pdfp'],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .only(
                                                      bottomStart:
                                                          Radius.elliptical(
                                                              20, 15),
                                                      bottomEnd:
                                                          Radius.elliptical(
                                                              20, 15),
                                                    ),
                                                  ),
                                                  elevation: 5,
                                                  child: Container(
                                                    height: tinggiLayar * 0.17,
                                                    width: lebarLayar * 0.25,
                                                    alignment: Alignment.center,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _launchURL(
                                                            snapshot.data[index]
                                                                ['gmbrp']);
                                                      },
                                                      child: CachedNetworkImage(
                                                        height:
                                                            tinggiLayar * 0.13,
                                                        width: lebarLayar * 0.2,
                                                        imageUrl:
                                                            snapshot.data[index]
                                                                ['gmbrp'],
                                                        progressIndicatorBuilder: (context,
                                                                url,
                                                                downloadProgress) =>
                                                            CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .data_usage,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Text('Jenis'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'jenisp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .format_list_numbered,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'Nomor ID'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      ['idp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .where_to_vote_sharp,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Text('Asal'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'asalp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .golf_course_sharp,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  Text('Untuk'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      [
                                                                      'untukp']),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(5, 0, 5, 0),
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .explicit_outlined,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    400],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  'Expired'),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  AutoSizeText(
                                                                snapshot.data[
                                                                        index]
                                                                    ['akhirp'],
                                                                style: TextStyle(
                                                                    color:
                                                                        _expiredColor),
                                                                softWrap: true,
                                                                maxLines: 1,
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
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          //info untuk kosong data
                        }

                        return Container();
                      });
                } else {
                  return Center(
                    child: Text('Mengambil Data...'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

void colorubah(indicators) {
  if (indicators == 1) {
    _aktifColor1=Colors.yellow.shade400;
    _aktifColor2=Colors.transparent;
    _aktifColor3=Colors.transparent;
    _aktifColor4=Colors.transparent;
    //abc
  } else if (indicators == 2) {
       _aktifColor1=Colors.transparent;
    _aktifColor2=Colors.yellow.shade400;
    _aktifColor3=Colors.transparent;
    _aktifColor4=Colors.transparent;
    //untuk
  } else if (indicators == 3) {
       _aktifColor1=Colors.transparent;
    _aktifColor2=Colors.transparent;
    _aktifColor3=Colors.yellow.shade400;
    _aktifColor4=Colors.transparent;
    //asal
  } else if (indicators == 4) {
       _aktifColor1=Colors.transparent;
    _aktifColor2=Colors.transparent;
    _aktifColor3=Colors.transparent;
    _aktifColor4=Colors.yellow.shade400;
    //expired
  } else if (indicators == 0){
       _aktifColor1=Colors.transparent;
    _aktifColor2=Colors.transparent;
    _aktifColor3=Colors.transparent;
    _aktifColor4=Colors.transparent;
  }
    //noting
  
}
