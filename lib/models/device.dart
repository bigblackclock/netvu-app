// To parse this JSON data, do
//
//     final lastPing = lastPingFromJson(jsonString);

import 'dart:convert';

LastPing lastPingFromJson(String str) => LastPing.fromJson(json.decode(str));

String lastPingToJson(LastPing data) => json.encode(data.toJson());

class LastPing {
    DateTime time;
    List<Device> devices;
    String id;

    LastPing({
        this.time,
        this.devices,
        this.id,
    });

    factory LastPing.fromJson(Map<String, dynamic> json) => LastPing(
        time: DateTime.parse(json["time"]),
        devices: List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "time": time.toIso8601String(),
        "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
        "_id": id,
    };
}

class Device {
    String name;
    String ip;
    String mac;
    String vendor;
    bool status;

    Device({
        this.name,
        this.ip,
        this.mac,
        this.vendor,
        this.status,
    });

    factory Device.fromJson(Map<String, dynamic> json) => Device(
        name: json["name"],
        ip: json["ip"],
        mac: json["mac"],
        vendor: json["vendor"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "ip": ip,
        "mac": mac,
        "vendor": vendor,
        "status": status,
    };
}
