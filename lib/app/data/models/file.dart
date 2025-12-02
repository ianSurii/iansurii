/**
 * @author [Ian Muthuri]
 * @email [ian.muthuri@outlook.com]
 * @create date 2025-12-01 18:05:42
 * @modify date 2025-12-01 18:06:11
 * @desc [Master of Many]
 */


import 'dart:convert';

File FileFromJson(String str) => File.fromJson(json.decode(str));

String FileToJson(File data) => json.encode(data.toJson());

class File {
    String name;
    String extension;
    String parentDirectory;
    String absolutePath;

    File({
        required this.name,
        required this.extension,
        required this.parentDirectory,
        required this.absolutePath,
    });

    factory File.fromJson(Map<String, dynamic> json) => File(
        name: json["name"],
        extension: json["extension"],
        parentDirectory: json["parent_directory"],
        absolutePath: json["absolute_path"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "extension": extension,
        "parent_directory": parentDirectory,
        "absolute_path": absolutePath,
    };
}
