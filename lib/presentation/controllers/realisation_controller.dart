import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imako_app/data/repositories/realisation_repository_impl.dart';
import 'package:imako_app/domain/entities/realisation.dart';

class RealisationController extends GetxController {
  final RealisationRepositoryImpl _repository = RealisationRepositoryImpl();

  final realisations = <Realisation>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRealisations();
  }

  Future<void> fetchRealisations() async {
    try {
      isLoading.value = true;
      final result = await _repository.getRealisations();
      realisations.assignAll(result);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les réalisations.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRealisation({
    required String description,
    required String title,
    required List<XFile> mediaFiles,
    String? whatsappNumber,
  }) async {
    try {
      isLoading.value = true;
      await _repository.createRealisation(
        description: description,
        title: title,
        mediaFiles: mediaFiles,
        whatsappNumber: whatsappNumber,
      );
      Get.back(); // Ferme le modal
      Get.snackbar('Succès', 'Votre réalisation a été publiée !');
      await fetchRealisations(); // Rafraîchit la liste
    } catch (e) {
      Get.snackbar('Erreur de publication', e.toString());
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
