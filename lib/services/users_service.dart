import 'package:chat/models/profile.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:http/http.dart' as http;

import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/global/environment.dart';

class UsuariosService {
  Future<List<User>> getUsers() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/users', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usersResponse = usuariosResponseFromJson(resp.body);
      print('${usersResponse}');
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }

  Future<List<Profiles>> getProfilesLastUsers() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/profile/last/users',
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });

      print('${resp}');

      final profilesResponse = profilesResponseFromJson(resp.body);

      return profilesResponse.profiles;
    } catch (e) {
      return [];
    }
  }
}
