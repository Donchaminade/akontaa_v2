
import 'package:akontaa/pages/dashboard_page.dart';
import 'package:akontaa/pages/my_debts_page.dart';
import 'package:akontaa/pages/owed_to_me_page.dart';
import 'package:akontaa/pages/payments_by_person_page.dart';
import 'package:akontaa/pages/settings_page.dart';
import 'package:akontaa/widgets/animated_background.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const MyDebtsPage(),
    const OwedToMePage(),
    const PaymentsByPersonPage(),
  ];

  final List<String> _pageTitles = [
    'Tableau de bord',
    'Mes dettes',
    'On me doit',
    'Paiements par personne',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimatedBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(_pageTitles[_selectedIndex]),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          body: _pages[_selectedIndex],
          extendBody: true,
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(_selectedIndex == 0 ? Icons.dashboard_rounded : Icons.dashboard_outlined),
                    label: 'Tableau de bord',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_selectedIndex == 1 ? Icons.arrow_upward_rounded : Icons.arrow_upward_outlined),
                    label: 'Mes dettes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_selectedIndex == 2 ? Icons.arrow_downward_rounded : Icons.arrow_downward_outlined),
                    label: 'On me doit',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(_selectedIndex == 3 ? Icons.people_alt : Icons.people_outline),
                    label: 'Paiements',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Colors.transparent,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                unselectedItemColor: Colors.white70,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                iconSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
