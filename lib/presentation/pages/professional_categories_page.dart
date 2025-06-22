import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart' as domain;
import '../controllers/professional_categories_controller.dart';
import 'details_profile_professionnel.dart';

class ProfessionalCategoriesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProfessionalCategoriesPage({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<ProfessionalCategoriesPage> createState() =>
      _ProfessionalCategoriesPageState();
}

class _ProfessionalCategoriesPageState
    extends State<ProfessionalCategoriesPage> {
  late final ProfessionalCategoriesController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfessionalCategoriesController());
    controller.loadProfessionalsForCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return Center(
              child: Text(controller.error.value,
                  style: const TextStyle(color: Colors.red)));
        }
        if (controller.professionals.isEmpty) {
          return const Center(
              child: Text('Aucun professionnel trouvé pour cette catégorie'));
        }
        return ListView.separated(
          itemCount: controller.professionals.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
          itemBuilder: (context, index) {
            final pro = controller.professionals[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFF1F5F9),
                backgroundImage: (pro.profileImageUrl != null &&
                        pro.profileImageUrl!.isNotEmpty)
                    ? NetworkImage(pro.profileImageUrl!)
                    : null,
                child: (pro.profileImageUrl == null ||
                        pro.profileImageUrl!.isEmpty)
                    ? Text(
                        (pro.companyName?.isNotEmpty == true)
                            ? pro.companyName![0].toUpperCase()
                            : (pro.firstName?.isNotEmpty == true)
                                ? pro.firstName![0].toUpperCase()
                                : 'P',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              title: Text(
                pro.companyName ?? (pro.firstName ?? ''),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              subtitle: Text(
                pro.activity ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      pro.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.message,
                        color: Color(0xFF4F8FFF), size: 20),
                    tooltip: 'Contacter',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Contacter ${pro.companyName ?? pro.firstName}')),
                      );
                    },
                  ),
                ],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              onTap: () {
                Get.to(() => DetailsProfileProfessionnel(
                      professionalId: pro.id,
                    ));
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              tileColor: Colors.white,
              dense: true,
            );
          },
        );
      }),
    );
  }
}
