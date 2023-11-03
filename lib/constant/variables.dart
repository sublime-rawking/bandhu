import 'package:bandhu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// server endpoint

const baseUrl = "http://192.168.29.129/BNI_25oct18/BNI_25oct18/";
const imageBaseUrl =
    "http://192.168.29.129/BNI_25oct18/BNI_25oct18/uploads/photo/";

const defaultprofileImage = "assets/images/default.png";
final StateProvider<User> userDataProvider = StateProvider<User>(
    (ref) => User(email: "", name: "", userid: "", image: "", phone: ""));

final otpContollerProvider = StateProvider((ref) => TextEditingController());
final screenIndexProvider = StateProvider((ref) => 0);
