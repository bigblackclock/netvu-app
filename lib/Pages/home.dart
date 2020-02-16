import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netvu/models/device.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LastPing lastPing;
  @override
  initState() {
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
                lastPing = snapshot.data;

                return Scaffold(
                  appBar: AppBar(
                    title: Text('NetVu'),
                    centerTitle: true,
                  ),
                  body: RefreshIndicator(
                    child: BodyWidget(lastPing),
                    onRefresh: () async {
                      LastPing newlastPing = await getLastPing();
                      setState(() {
                        lastPing = newlastPing;
                      });
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget BodyWidget(LastPing lastPing) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.yellow,
          child: Text(
            "Last Scan : ${lastPing.timestamp.toString()}",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Dashbored(lastPing),
        Flexible(
          child: ListView.builder(
              itemCount: lastPing.devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  subtitle: (Text(lastPing.devices[index].vendor)),
                  title: Text(lastPing.devices[index].ip),
                  trailing: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lastPing.devices[index].status == true
                            ? Colors.green
                            : Colors.red),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Future<LastPing> getLastPing() async {
    try {
      Response response = await Dio().get("https://pi.hadi.wtf/lp");

      return sort(LastPing.fromJson(json.decode(response.toString())));
    } catch (e) {
      print('err');
      print(e);
    }
  }

// To Sort Devices from online to offline
  LastPing sort(LastPing lastPing) {
    List<Device> devices = lastPing.devices;
    List<Device> listOn = [];
    List<Device> listOff = [];
    for (int i = 0; i < devices.length; i++) {
      if (devices[i].status == true) {
        listOn.add(devices[i]);
      } else {
        listOff.add(devices[i]);
      }
    }
    lastPing.devices = new List.from(listOn)..addAll(listOff);
    return lastPing;
  }

  Widget Dashbored(LastPing lastPing) {
    List<Device> devices = lastPing.devices;
    List<Device> listOn = [];
    List<Device> listOff = [];
    for (int i = 0; i < devices.length; i++) {
      if (devices[i].status == true) {
        listOn.add(devices[i]);
      } else {
        listOff.add(devices[i]);
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.blue),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //         <--- border radius here
                ),
          ),
          child: new Container(
            height: 60,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('All Devices',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
                Text(
                  devices.length.toString(),
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        new Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: new Container(
            height: 60,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Online Devices',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
                Text(
                  listOn.length.toString(),
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        new Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: new Container(
            height: 60,
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Offline Devices',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                Text(
                  listOff.length.toString(),
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
