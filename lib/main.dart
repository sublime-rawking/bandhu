// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/screens/authscreen/login.dart';
import 'package:bandhu/screens/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Bandhu',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
                .copyWith(background: Colors.white)),
        home: const Main(),
      ),
    ),
  );
}

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  double loader = 0;
  final userLoaded = StateProvider<bool>((ref) => false);
  callInitState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("user") != null) {
      Map<String, dynamic> userData =
          jsonDecode(prefs.getString("user").toString());
      ref.watch(userDataProvider.notifier).state = User.fromMap(userData);
      ref.watch(userLoaded.notifier).state = true;
      Auth().getUserData(ref: ref, context: context);
    }
    FlutterNativeSplash.remove();
    setState(() {
      loader = 1.0;
    });
  }

  @override
  void initState() {
    callInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: loader,
        child: ref.read(userLoaded) ? const Navbar() : const LoginScreen());
  }
}
