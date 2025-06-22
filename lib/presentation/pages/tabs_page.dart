import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imako_app/presentation/pages/profile_page.dart';
import '../controllers/auth_controller.dart';
import '../../domain/entities/user.dart' as domain;
import '../../data/models/user_model.dart';
import 'home_page.dart';
import 'realisations_page.dart';
import 'professional_profile_page.dart';


class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser as UserModel?;
    final isProfessional =
        currentUser?.userType == domain.UserType.professional;

    final List<Widget> pages = isProfessional
        ? [
            const HomePage(),
             RealisationsPage(),
            const ProfessionalProfilePage(),
          ]
        : [
            const HomePage(),
             RealisationsPage(),
            const ProfileParticulierPage(),
          ];

    final List<BottomNavigationBarItem> items = isProfessional
        ? [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Réalisations',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ]
        : [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              label: 'Réalisations',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF8FAFC),
        selectedItemColor: const Color(0xFF0F172A),
        unselectedItemColor: const Color(0xFF64748B),
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        items: items,
      ),
    );
  }
}

// Pages temporaires pour les onglets
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Page des Services',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Page des Rendez-vous',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Page de Recherche',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Page des Favoris',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Page du Profil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
