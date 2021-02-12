import 'package:chat/global/environment.dart';
import 'package:chat/models/air.dart';
import 'package:chat/models/air_response.dart';
import 'package:chat/models/aires_response.dart';
import 'package:chat/models/subscribe.dart';
import 'package:chat/models/subscription_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SubscriptionApiProvider {
  final String _endpoint = '${Environment.apiUrl}/subscription/';

  final _storage = new FlutterSecureStorage();

  Future<Subscription> getSubscription(String subId, String clubId) async {
    final urlFinal = _endpoint + 'subscription' + '/$subId' + '/$clubId';

    final token = await this._storage.read(key: 'token');

    try {
      print(urlFinal);
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      print(resp.body);
      final subscriptionResponse = subscriptionResponseFromJson(resp.body);

      print(subscriptionResponse);
      return subscriptionResponse.subscription;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Subscription(id: '0');
    }
  }

  Future<List<Air>> getAiresRoom(String roomId) async {
    final urlFinal = _endpoint + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airesResponse = airesResponseFromJson(resp.body);
      return airesResponse.airs;
    } catch (e) {
      return [];
    }
  }

  final String _endpointRoom = '${Environment.apiUrl}/plant/plant/';

  Future<Air> getAir(String roomId) async {
    final urlFinal = _endpointRoom + '$roomId';

    final token = await this._storage.read(key: 'token');

    try {
      final resp = await http.get(urlFinal,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      final airResponse = airResponseFromJson(resp.body);
      return airResponse.air;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return new Air(id: '0');
    }
  }

  Future deleteAir(String airId) async {
    final token = await this._storage.read(key: 'token');

    try {
      await http.delete('${Environment.apiUrl}/air/delete/$airId',
          headers: {'Content-Type': 'application/json', 'x-token': token});

      return true;
    } catch (e) {
      return false;
    }
  }
}
