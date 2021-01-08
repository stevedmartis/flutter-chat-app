import 'package:chat/models/profiles_response.dart';
import 'package:chat/providers/users_provider.dart';

class UsersRepository {
  UsersProvider _apiProvider = UsersProvider();

  Future<ProfilesResponse> getPrincipalSearch(String query) {
    return _apiProvider.getSearchPrincipalByQuery(query);
  }
}
