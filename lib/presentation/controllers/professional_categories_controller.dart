import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalCategoriesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<UserModel> professionals = <UserModel>[].obs;
  final RxString error = ''.obs;

  Future<void> loadProfessionalsForCategory(String categoryName) async {
    print(
        '[ProfessionalCategoriesController] Chargement des pros pour la catégorie : $categoryName');
    isLoading.value = true;
    error.value = '';
    professionals.clear();
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'professional')
          .get();
      print(
          '[ProfessionalCategoriesController] Résultats Firestore : ${query.docs.length} documents');
      final allPros =
          query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
      professionals.value = allPros
          .where((pro) =>
              pro.activity != null &&
              pro.activity!
                  .split(',')
                  .map((e) => e.trim())
                  .contains(categoryName))
          .toList();
      print(
          '[ProfessionalCategoriesController] Pros filtrés : ${professionals.length}');
    } catch (e) {
      print('[ProfessionalCategoriesController] Erreur : $e');
      error.value = 'Erreur lors du chargement : $e';
    } finally {
      isLoading.value = false;
      print('[ProfessionalCategoriesController] Chargement terminé.');
    }
  }
}
