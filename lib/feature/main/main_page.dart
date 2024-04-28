import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_assistant/feature/books/view/book_page.dart';
import 'package:virtual_assistant/feature/history/view/histor_page.dart';
import 'package:virtual_assistant/generated/assets.dart';
import 'package:virtual_assistant/utils/pallet.dart';
import '../home/view/home_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _selectedIndex != 0
            ? AppBar(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(Assets.imagesPALogo, height: 50),
                ),
                backgroundColor: Pallet.whiteColor,
                elevation: 0,
              )
            : null,
        body: _selectedIndex == 0
            ? const HomePage()
            : _selectedIndex == 1
                ? const HistoryPage()
                : const BooksListScreen(),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(
              fontFamily: 'Cera Pro',
              fontWeight: FontWeight.w700,
              color: Pallet.mainFontColor),
          unselectedLabelStyle: const TextStyle(
              fontFamily: 'Cera Pro',
              fontWeight: FontWeight.w400,
              color: Colors.black54),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Book Lookup',
            ),
          ],
        ),
      ),
    );
  }
}
