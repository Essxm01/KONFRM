import 'package:flutter/material.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

import '../../features/account/presentation/account_view.dart';
import '../../features/bookings/presentation/bookings_view.dart';
import '../../features/discovery/presentation/explore_view.dart';
import '../../features/favorites/presentation/favorites_view.dart';

/// Root shell for KONFRM | GUEST Flutter client.
///
/// Implements the 4-destination navigation architecture:
/// - 0: استكشف (Explore)
/// - 1: المفضلة (Favorites)
/// - 2: حجوزاتي (Bookings)
/// - 3: الحساب (Account)
///
/// Handles Android system back navigation:
/// - Tabs 1..3 return to tab 0 (Explore).
/// - Tab 0 permits system exit/pop.
class CustomerAppShell extends StatefulWidget {
  const CustomerAppShell({super.key});

  @override
  State<CustomerAppShell> createState() => _CustomerAppShellState();
}

class _CustomerAppShellState extends State<CustomerAppShell> {
  int _selectedIndex = 0;

  void _onSelectTab(int index) {
    if (index >= 0 && index < 4 && index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              const ExploreView(),
              FavoritesView(onExplore: () => _onSelectTab(0)),
              BookingsView(onExplore: () => _onSelectTab(0)),
              const AccountView(),
            ],
          ),
        ),
        bottomNavigationBar: CustomerBottomNavigation(
          selectedIndex: _selectedIndex,
          onSelected: _onSelectTab,
        ),
      ),
    );
  }
}
