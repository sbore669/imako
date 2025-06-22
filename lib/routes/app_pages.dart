import 'package:get/get.dart';
import '../presentation/pages/welcome_page.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/register_particular_page.dart';
import '../presentation/pages/register_professional_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/tabs_page.dart';
import '../presentation/pages/auth_test_page.dart';
import '../presentation/bindings/auth_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(name: Routes.WELCOME, page: () => WelcomePage()),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER_PARTICULAR,
      page: () => RegisterParticularPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER_PROFESSIONAL,
      page: () => RegisterProfessionalPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.TABS,
      page: () => const TabsPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.AUTH_TEST,
      page: () => const AuthTestPage(),
      binding: AuthBinding(),
    ),
  ];
}
