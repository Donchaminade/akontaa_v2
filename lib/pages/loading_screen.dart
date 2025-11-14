import 'package:akontaa/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:akontaa/pages/home_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:akontaa/providers/debt_provider.dart';

class LoadingScreen extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const LoadingScreen({super.key, required this.changeTheme});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    try {
      // Load debts and events before navigating to home page
      await Provider.of<DebtProvider>(context, listen: false).loadDebts();
      await Provider.of<EventProvider>(context, listen: false).loadEvents();
    } catch (e) {
      print("Erreur lors du chargement des données: $e");
      // En cas d'erreur, on continue quand même pour ne pas bloquer l'utilisateur
    }

    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(showOnboarding: false, changeTheme: widget.changeTheme),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background
      appBar: AppBar(
        title:
            const Text('Chargement...', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerItem(height: 20, width: 150), // Title placeholder
            const SizedBox(height: 20),
            _buildShimmerItem(height: 100), // Card placeholder
            const SizedBox(height: 20),
            _buildShimmerItem(height: 20, width: 200), // Section title
            const SizedBox(height: 10),
            _buildShimmerItem(height: 50), // List item placeholder
            const SizedBox(height: 10),
            _buildShimmerItem(height: 50), // List item placeholder
            const SizedBox(height: 10),
            _buildShimmerItem(height: 50), // List item placeholder
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850], // Darker bottom nav
        items: [
          BottomNavigationBarItem(
            icon: _buildShimmerItem(height: 24, width: 24), // Icon placeholder
            label: '  ', // Label placeholder
          ),
          BottomNavigationBarItem(
            icon: _buildShimmerItem(height: 24, width: 24), // Icon placeholder
            label: '  ', // Label placeholder
          ),
          BottomNavigationBarItem(
            icon: _buildShimmerItem(height: 24, width: 24), // Icon placeholder
            label: '  ', // Label placeholder
          ),
          BottomNavigationBarItem(
            icon: _buildShimmerItem(height: 24, width: 24), // Icon placeholder
            label: '  ', // Label placeholder
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildShimmerItem(
      {double height = 16, double? width, double borderRadius = 4}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // Shimmer effect will override this color
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
