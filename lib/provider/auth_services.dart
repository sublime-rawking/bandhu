import 'dart:convert';

import 'package:bandhu/constant/pref_keys.dart';
import 'package:bandhu/provider/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth_api.dart';
import '../constant/variables.dart';
import '../model/user_model.dart';

class AuthServices {
  static AuthServices? _instance;
  SharedPreferences? prefs;

  AuthServices._();

  static AuthServices get instance => _instance ??= AuthServices._();
  final StateProvider<User> userDataProvider =
      StateProvider<User>((ref) => User());

  final StateProvider<bool> isAuth = StateProvider<bool>((ref) => false);

  initServices(WidgetRef ref) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs == null) {
      return;
    }
    if (prefs!.containsKey(PrefKeys.instance.userKey)) {
      var data = prefs?.getString(PrefKeys.instance.userKey);
      if (data != null) {
        ref.watch(userDataProvider.notifier).state =
            User.fromJson(jsonDecode(data));
        if (ref.watch(userDataProvider).token != null &&
            ref.watch(userDataProvider).token != "") {
          ref.watch(isAuth.notifier).state = true;
          ApiServices.instance.setToken(ref.watch(userDataProvider).token!);
          await Auth.instance.getUserData(ref: ref,);
        }
      }
    }
  }

  setToken(User user, ref) async {
    if (user.token != null && user.token != "") {
      ref.watch(userDataProvider.notifier).state =user;
      prefs?.setString(PrefKeys.instance.userKey, jsonEncode(user.toJson()));
      ref.watch(isAuth.notifier).state = true;
      ApiServices.instance.setToken(user.token!);
    }
  }

Future<bool>  removeToken( ref) async {
  try{
      prefs?.remove(PrefKeys.instance.userKey);
      ref.watch(isAuth.notifier).state = false;
      ref.watch(screenIndexProvider.notifier).state = 0;
      ApiServices.instance.clearClient();
      return true;
    } catch(e){
      return false;
    }
  }
}
