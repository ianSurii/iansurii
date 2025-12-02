// To parse this JSON data, do
//
//     final app = appFromJson(jsonString);

import 'dart:convert';

App appFromJson(String str) => App.fromJson(json.decode(str));

String appToJson(App data) => json.encode(data.toJson());

class App {
    String id;
    String name;
    String icon;
    String route;
    List<String> supportedExtensions;

    App({
        required this.id,
        required this.name,
        required this.icon,
        required this.route,
        required this.supportedExtensions,
    });

    factory App.fromJson(Map<String, dynamic> json) => App(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        route: json["route"],
        supportedExtensions: List<String>.from(json["supported_extensions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "route": route,
        "supported_extensions": List<dynamic>.from(supportedExtensions.map((x) => x)),
    };
}
