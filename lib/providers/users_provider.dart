import 'package:chat/models/usuario.dart';
import 'package:chat/services/users_service.dart';

import 'dart:async';

class UsersProvider {
  final usuarioService = new UsuariosService();

  String _apikey = '4bc0335f07b79c1a9cf3111e7b778f89';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPage = 0;
  bool _loading = false;

  List<User> _popular = new List();

  final _popularStreamController = StreamController<List<User>>.broadcast();

  Function(List<User>) get popularSink => _popularStreamController.sink.add;

  Stream<List<User>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<User>> _answerMethod(Uri url) async {
    final users = await usuarioService.getUsers();

    return (users);
  }

  Future<List<User>> getMovies() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _answerMethod(url);
  }

  Future<List<User>> getPopulares() async {
    if (_loading) return [];

    _loading = true;

    _popularPage++;

    final users = await usuarioService.getUsers();

    _popular.addAll(users);
    popularSink(_popular);

    _loading = false;

    return users;
  }

  Future<List<User>> searchMovie(String query) async {
    final url = Uri.http(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _answerMethod(url);
  }
}
