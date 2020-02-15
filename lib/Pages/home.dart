import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netvu/models/device.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: getLastPing(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(height: 30, child: CircularProgressIndicator())
                  ],
                );
              } else {
                LastPing lastPing = snapshot.data;
                return Scaffold(
                  appBar: AppBar(
                    title: Text('NetVu'),
                    centerTitle: true,
                  ),
                  body: Column(
                    children: <Widget>[
                      Text("Last Scan :${lastPing.time.toString()}"),
                      Flexible(
                        child: ListView.builder(
                            itemCount: lastPing.devices.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                subtitle:
                                    (Text(lastPing.devices[index].vendor)),
                                title: Text(lastPing.devices[index].ip),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<LastPing> getLastPing() async {
    try {
      Response response = await Dio().get("https://pi.hadi.wtf/lastping");
      return LastPing.fromJson(json.decode(response.toString()));
    } catch (e) {
      print(e);
    }
  }
}
