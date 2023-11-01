import 'package:bandhu/screens/navbar/navbar.dart';
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
  callInitState() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // Map userData = jsonDecode(prefs.getString("userData").toString());
    // if (prefs.getString("userData") != null) {}
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
        child: const Navbar());
  }
}
