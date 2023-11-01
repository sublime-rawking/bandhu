import 'package:bandhu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// server endpoint

const baseUrl = "http://192.168.240.203:3000/api/v1";
const imageBaseUrl = "http://192.168.240.203:3000/images";

const defaultprofileImage = "assets/images/person.png";
final StateProvider<User> userDataProvider = StateProvider<User>(
    (ref) => User(email: "", name: "", userid: "", image: "", phone: ""));

final otpContollerProvider = StateProvider((ref) => TextEditingController());
final screenIndexProvider = StateProvider((ref) => 0);
