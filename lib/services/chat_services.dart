import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/mensaje_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    try {
      final resp = await http
          .get('${Environment.apiUrl}/mensaje/mensajes/$usuarioId', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      print(resp.statusCode);
      if (resp.statusCode == 200) {
        final msjResp = mensajesResponseFromJson(resp.body);
        
        return msjResp.mensajes;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
