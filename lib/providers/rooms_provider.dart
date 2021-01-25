import 'package:chat/global/environment.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/room_response.dart';
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

  final String _endpointRoom = '${Environment.apiUrl}/room/room/';

  Future<Room> getRoom(String roomId) async {
    final urlFinal = _endpointRoom + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      print(resp);
      final roomsResponse = roomResponseFromJson(resp.body);
      return roomsResponse.room;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Room();
    }
  }
}
