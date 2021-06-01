import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuario_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuario/usuarios',
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        print(resp.body);
        final usuariosResp = usuariosResponseFromJson(resp.body);
        return usuariosResp.usuarios;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateToken(String token) async {
    Map<String, dynamic> datos =
        JwtDecoder.decode(await AuthService.getToken());
    print("decoded  $datos");
    String id = datos['uid'];
    final data = {'token': token};
    final res = await http.put('${Environment.apiUrl}/usuario/update/$id',
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
