

class PrefKeys {
  static PrefKeys? _instance;

  PrefKeys._();

  static PrefKeys get instance => _instance ??= PrefKeys._();

  String userKey = "userKey";
  String tokenKey = "tokenKey";
}
