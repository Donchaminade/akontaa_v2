import 'dart:ui';
import 'package:akontaa/app_colors.dart';
import 'package:akontaa/pages/dashboard_page.dart';
import 'package:akontaa/pages/my_debts_page.dart';
import 'package:akontaa/pages/owed_to_me_page.dart';
import 'package:akontaa/pages/transaction_history_page.dart';
import 'package:akontaa/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final bool showOnboarding;
  final Function(ThemeMode) changeTheme;
  const HomePage({super.key, this.showOnboarding = false, required this.changeTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final GlobalKey _appBarTitleKey = GlobalKey();
  final GlobalKey _settingsButtonKey = GlobalKey();
  final GlobalKey _dashboardNavItemKey = GlobalKey();
  final GlobalKey _myDebtsNavItemKey = GlobalKey();
  final GlobalKey _owedToMeNavItemKey = GlobalKey();
  final GlobalKey _paymentsNavItemKey = GlobalKey();

  final List<Widget> _pages = [
    const DashboardPage(),
    const MyDebtsPage(),
    const OwedToMePage(),
    const TransactionHistoryPage(),
  ];

  final List<String> _pageTitles = [
    'Tableau de bord',
    'Mes dettes',
    'On me doit',
    'Paiements par personne',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.showOnboarding) {
      _showOnboarding();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showOnboarding() async {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: _appBarTitleKey,
        keyTarget: _appBarTitleKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Bienvenue sur Akontaa!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Ceci est le titre de l'application. Il indique la page actuelle.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: _settingsButtonKey,
        keyTarget: _settingsButtonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Paramètres",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Accédez aux paramètres de l'application ici.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: _dashboardNavItemKey,
        keyTarget: _dashboardNavItemKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Tableau de bord",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Vue d'ensemble de vos dettes et créances.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: _myDebtsNavItemKey,
        keyTarget: _myDebtsNavItemKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Mes dettes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Gérez l'argent que vous devez.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: _owedToMeNavItemKey,
        keyTarget: _owedToMeNavItemKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "On me doit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Gérez l'argent que l'on vous doit.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: _paymentsNavItemKey,
        keyTarget: _paymentsNavItemKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Paiements",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Historique de tous les paiements.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    TutorialCoachMark(targets: targets, 
      colorShadow: Colors.black,
      textSkip: "PASSER",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenOnboarding', true);
      },
      onSkip: () {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('hasSeenOnboarding', true);
        });
        return true;
      },
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex], key: _appBarTitleKey),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => SettingsPage(changeTheme: widget.changeTheme)),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 70, // Increased height
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 0 ? Icons.dashboard_rounded : Icons.dashboard_outlined, key: _dashboardNavItemKey),
                  label: 'Dash',
                ),
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 1 ? Icons.arrow_upward_rounded : Icons.arrow_upward_outlined, key: _myDebtsNavItemKey),
                  label: 'Mes dettes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 2 ? Icons.arrow_downward_rounded : Icons.arrow_downward_outlined, key: _owedToMeNavItemKey),
                  label: 'On me doit',
                ),
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 3 ? Icons.people_alt : Icons.people_outline, key: _paymentsNavItemKey),
                  label: 'Paiements',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: const Color.fromARGB(232, 59, 59, 59),
              selectedItemColor: AppColors.green,
              unselectedItemColor: Colors.white70,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedFontSize: 12.0,
              unselectedFontSize: 0,
              iconSize: 28, // Increased icon size
            ),
          ),
        ),
      ),
    );
  }
}
