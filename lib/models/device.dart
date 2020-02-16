// To parse this JSON data, do
//
//     final lastPing = lastPingFromJson(jsonString);

import 'dart:convert';

LastPing lastPingFromJson(String str) => LastPing.fromJson(json.decode(str));

String lastPingToJson(LastPing data) => json.encode(data.toJson());

class LastPing {
    DateTime timestamp;
    List<Device> devices;

    LastPing({
        this.timestamp,
        this.devices,
    });

    factory LastPing.fromJson(Map<String, dynamic> json) => LastPing(
        timestamp: DateTime.parse(json["timestamp"]),
        devices: List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
    };
}

class Device {
    String ip;
    String mac;
    String name;
    bool status;
    String vendor;

    Device({
        this.ip,
        this.mac,
        this.name,
        this.status,
        this.vendor,
    });

    factory Device.fromJson(Map<String, dynamic> json) => Device(
        ip: json["ip"],
        mac: json["mac"],
        name: json["name"],
        status: json["status"],
        vendor: json["vendor"],
    );

    Map<String, dynamic> toJson() => {
        "ip": ip,
        "mac": mac,
        "name": name,
        "status": status,
        "vendor": vendor,
    };
}
