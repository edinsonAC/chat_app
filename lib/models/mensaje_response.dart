// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

MensajeResponse mensajesResponseFromJson(String str) =>
    MensajeResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajeResponse data) =>
    json.encode(data.toJson());

class MensajeResponse {
  MensajeResponse({
    this.ok,
    this.mensajes,
  });

  bool ok;
  List<Mensaje> mensajes;

  factory MensajeResponse.fromJson(Map<String, dynamic> json) =>
      MensajeResponse(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x)),
      };
}

class Mensaje {
  Mensaje({this.de, this.para, this.mensaje, this.createdAt, this.updatedAt});
  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
