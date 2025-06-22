import 'dart:io';

import 'package:image_picker/image_picker.dart';
import '../entities/realisation.dart';

abstract class RealisationRepository {
  Future<List<Realisation>> getRealisations();
  Future<void> createRealisation({
    required String description,
    required String title,
    required List<XFile> mediaFiles,
    String? whatsappNumber,
  });
}
