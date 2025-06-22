import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/config/env_config.dart';

class MinioService {
  late final Minio _minio;
  final String _bucketName;

  MinioService() : _bucketName = EnvConfig.minioBucketName {
    _minio = Minio(
      endPoint: EnvConfig.minioEndpoint,
      port: int.parse(EnvConfig.minioPort),
      accessKey: EnvConfig.minioAccessKey,
      secretKey: EnvConfig.minioSecretKey,
      useSSL: EnvConfig.minioUseSsl,
    );
  }

  Future<String> uploadFile(File file, String path) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.split('/').last}';
      final filePath = 'uploads/$fileName';

      // Créer un StreamController pour les bytes
      final controller = StreamController<Uint8List>();

      // Lire le fichier et envoyer les bytes au stream
      final bytes = await file.readAsBytes();
      controller.add(bytes);
      controller.close();

      // Upload du fichier
      await _minio.putObject(_bucketName, filePath, controller.stream);

      // On retourne l'URL publique complète
      return getFileUrl(filePath);
    } catch (e) {
      print('Erreur lors de l\'upload vers MinIO: $e');
      rethrow;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      await _minio.removeObject(_bucketName, path);
    } catch (e) {
      print('Erreur lors de la suppression du fichier MinIO: $e');
      rethrow;
    }
  }

  String getFileUrl(String path) {
    // Si le chemin contient déjà l'URL complète, le retourner tel quel
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Sinon, construire l'URL avec le chemin relatif
    final scheme = EnvConfig.minioUseSsl ? 'https' : 'http';
    return '$scheme://${EnvConfig.minioEndpoint}:${EnvConfig.minioPort}/$_bucketName/$path';
  }
}
