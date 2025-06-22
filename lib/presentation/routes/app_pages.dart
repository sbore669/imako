import 'package:get/get.dart';
import 'package:imako_app/presentation/pages/welcome_page.dart';
import '../pages/login_page.dart';
import '../pages/register_particular_page.dart';
import '../pages/register_professional_page.dart';
import '../pages/home_page.dart';
import '../pages/all_categories_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => const LoginPage()),
    GetPage(name: Routes.WELCOME, page: () => const WelcomePage()),
    GetPage(
      name: Routes.REGISTER_PARTICULAR,
      page: () => RegisterParticularPage(),
    ),
    GetPage(
      name: Routes.REGISTER_PROFESSIONAL,
      page: () => RegisterProfessionalPage(),
    ),
    GetPage(name: Routes.HOME, page: () => const HomePage()),
    GetPage(name: Routes.ALL_CATEGORIES, page: () => const AllCategoriesPage()),
  ];
}
