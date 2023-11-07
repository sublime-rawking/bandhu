import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/screens/navbar/home_screen.dart';
import 'package:bandhu/screens/navbar/profile_pdf_screen.dart';
import 'package:bandhu/screens/navbar/profile_screen.dart';
import 'package:bandhu/screens/navbar/userlist_screen.dart';
import 'package:bandhu/screens/widget/ask_give_popup.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavbarState();
}

class _NavbarState extends ConsumerState<Navbar> {
  @override
  void initState() {
    super.initState();
  }

  onPressAddBtn() => showDialog(
      context: context,
      builder: (builder) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const AskGivePopup()));

  @override
  Widget build(
    BuildContext context,
  ) {
    int index = ref.watch(screenIndexProvider);
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: const [
            HomeScreen(),
            UserListScreen(),
            PdfProfileScreen(),
            ProfileScreen()
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: onPressAddBtn,
        backgroundColor: colorPrimary,
        tooltip: 'Add',
        heroTag: "Add",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              activeIcon: Icon(
                Icons.home,
                color: colorPrimary,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.chat_rounded),
              activeIcon: Icon(
                Icons.chat_rounded,
                color: colorPrimary,
              ),
              label: "Users"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.picture_as_pdf_sharp),
              activeIcon: Icon(
                Icons.picture_as_pdf_sharp,
                color: colorPrimary,
              ),
              label: "Pdf"),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              activeIcon: Icon(
                Icons.person,
                color: colorPrimary,
              ),
              label: "Profile")
        ],
        selectedItemColor: colorPrimary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        unselectedLabelStyle: TextStyle(
          color: const Color(0xFF5A5A5A),
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
        selectedIconTheme: IconThemeData(color: colorPrimary),
        selectedLabelStyle: TextStyle(
          color: const Color(0xFFE63246),
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        iconSize: 24,
        currentIndex: ref.watch(screenIndexProvider),
        onTap: (index) => ref.watch(screenIndexProvider.notifier).state = index,
      ),
    );
  }
}
