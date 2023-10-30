import 'package:bandhu/screens/authscreen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Bandhu',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
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
  @override
  void initState() {
    FlutterNativeSplash.remove();
    setState(() {
      loader = 1.0;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: loader,
        child: const LoginScreen());
  }
}
