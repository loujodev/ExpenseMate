import 'package:expense_mate/src/features/categorypage/presentation/category_page.dart';
import 'package:expense_mate/src/features/dashboardpage/dashboard_page.dart';
import 'package:expense_mate/src/features/profilepage/presentation/profile_page.dart';
import 'package:expense_mate/src/features/rooting/navigation_bar.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:flutter/material.dart';

///MainScreen consists of a [PageView] to navigate between different pages.
///It has a List of the three pages and a [_pageController] to keep track of the currently selected page
///It allows swiping between the different pages and updates the selected page on the [NavigationBarWidget]

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DashboardPage(),
    const CategoryPage(),
    const ProfilePage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///used to update [NavigationBarWidget] and trigger animation when switching pages
  void _onDestinationSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();
    return Scaffold(
      backgroundColor: theme?.mainBackGroundColor,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _pages,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.075,
            child: NavigationBarWidget(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
          ),
        ],
      ),
    );
  }
}
