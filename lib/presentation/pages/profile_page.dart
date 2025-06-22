import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../data/models/user_model.dart';

class ProfileParticulierPage extends StatefulWidget {
  const ProfileParticulierPage({super.key});

  @override
  State<ProfileParticulierPage> createState() => _ProfileParticulierPageState();
}

class _ProfileParticulierPageState extends State<ProfileParticulierPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final currentUser = Get.find<AuthController>().currentUser as UserModel?;
    _firstNameController =
        TextEditingController(text: currentUser?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: currentUser?.lastName ?? '');
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _phoneController = TextEditingController(text: currentUser?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Get.find<AuthController>().currentUser as UserModel?;
    final initial = (currentUser?.firstName?.isNotEmpty == true)
        ? currentUser!.firstName![0].toUpperCase()
        : 'U';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFF1F5F9),
                backgroundImage: currentUser?.profileImageUrl != null &&
                        currentUser!.profileImageUrl!.isNotEmpty
                    ? NetworkImage(currentUser!.profileImageUrl!)
                    : null,
                child: (currentUser?.profileImageUrl == null ||
                        currentUser!.profileImageUrl!.isEmpty)
                    ? Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F8FFF),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            _buildEditableField(context,
                label: 'Prénom',
                value: _firstNameController.text,
                onChanged: (val) =>
                    setState(() => _firstNameController.text = val)),
            const SizedBox(height: 16),
            _buildEditableField(context,
                label: 'Nom',
                value: _lastNameController.text,
                onChanged: (val) =>
                    setState(() => _lastNameController.text = val)),
            const SizedBox(height: 16),
            _buildDisplayField(label: 'Email', value: _emailController.text),
            const SizedBox(height: 16),
            _buildEditableField(context,
                label: 'Téléphone',
                value: _phoneController.text,
                onChanged: (val) =>
                    setState(() => _phoneController.text = val)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Ajouter la logique de modification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Modification enregistrée (à implémenter)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F8FFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Modifier'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.find<AuthController>().signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.logout, size: 22),
                label: const Text('Se déconnecter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(BuildContext context,
      {required String label,
      required String value,
      required ValueChanged<String> onChanged}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final controller = TextEditingController(text: value);
        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Modifier $label'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        );
        if (result != null && result != value) {
          onChanged(result);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(value.isEmpty ? 'Non renseigné' : value,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.edit, size: 18, color: Color(0xFFB0B8C1)),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayField({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const SizedBox(height: 2),
          Text(value.isEmpty ? 'Non renseigné' : value,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
