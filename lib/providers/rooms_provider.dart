import 'package:chat/global/environment.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RoomsApiProvider {
  final String _endpoint = '${Environment.apiUrl}/room/rooms/user/';

  final _storage = new FlutterSecureStorage();

  Future<RoomsResponse> getRooms(String userId) async {
    final urlFinal = _endpoint + '$userId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final roomsResponse = roomsResponseFromJson(resp.body);
      return roomsResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RoomsResponse.withError("$error");
    }
  }
}
