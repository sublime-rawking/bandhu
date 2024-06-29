// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/provider/auth_services.dart';
import 'package:bandhu/screens/authscreen/login.dart';
import 'package:bandhu/screens/navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The entry point of the application.
void main() {
  // Initialize Flutter widgets bindings.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve native splash screen.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Run the application.
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reffergenix',
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              .copyWith(background: Colors.white),
        ),
        // Set the home page of the application.
        home: const Main(),
      ),
    ),
  );
}

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  /// Creates the state for the [Main] widget.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  double loader = 0;

  /// Calls the initialization state.
  callInitState() async {
    await AuthServices.instance.initServices(ref);
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
        child: ref.read(AuthServices.instance.isAuth)
            ? const Navbar() // Show the Navbar if userLoaded is true
            : const LoginScreen() // Show the LoginScreen if userLoaded is false
        );
  }
}
