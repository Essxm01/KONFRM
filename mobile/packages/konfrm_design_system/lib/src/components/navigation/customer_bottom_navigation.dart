import 'package:flutter/material.dart';

const customerDestinations = <String>['استكشف', 'المفضلة', 'حجوزاتي', 'الحساب'];

class CustomerBottomNavigation extends StatelessWidget {
  const CustomerBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  static const _icons = [
    Icons.explore_outlined,
    Icons.favorite_border,
    Icons.bookmark_border,
    Icons.person_outline,
  ];
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      destinations: List.generate(
        customerDestinations.length,
        (index) => SizedBox(
          key: Key('customer-destination-$index'),
          child: NavigationDestination(
            icon: Icon(_icons[index]),
            selectedIcon: Icon(_icons[index]),
            label: customerDestinations[index],
            tooltip: customerDestinations[index],
          ),
        ),
      ),
    ),
  );
}
