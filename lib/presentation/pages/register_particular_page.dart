import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/auth_controller.dart';

class RegisterParticularPage extends StatelessWidget {
  RegisterParticularPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final _currentStep = 0.obs;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      _authController.setProfileImage(File(image.path));
    }
  }

  Widget _buildStepIndicator() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _currentStep.value >= index ? Colors.black : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    return Obx(() {
      switch (_currentStep.value) {
        case 0:
          return _buildPersonalInfoStep();
        case 1:
          return _buildContactInfoStep();
        case 2:
          return _buildSecurityStep();
        default:
          return const SizedBox.shrink();
      }
    });
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        const Text(
          'Informations personnelles',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        // Photo de profil
        Center(
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  image:
                      _authController.profileImage.value != null
                          ? DecorationImage(
                            image: FileImage(
                              _authController.profileImage.value!,
                            ),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    _authController.profileImage.value == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(
            labelText: 'Prénom',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre prénom';
            }
            if (value.length < 2) {
              return 'Le prénom doit contenir au moins 2 caractères';
            }
            if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value)) {
              return 'Le prénom ne doit contenir que des lettres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(
            labelText: 'Nom',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre nom';
            }
            if (value.length < 2) {
              return 'Le nom doit contenir au moins 2 caractères';
            }
            if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value)) {
              return 'Le nom ne doit contenir que des lettres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactInfoStep() {
    return Column(
      children: [
        const Text(
          'Informations de contact',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre email';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Veuillez entrer un email valide';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Téléphone',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
            hintText: '06 12 34 56 78',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre numéro de téléphone';
            }
            // Suppression des espaces et des caractères spéciaux
            final cleanNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
            // Vérifie simplement si le numéro contient au moins 10 chiffres
            if (cleanNumber.length < 7) {
              return 'Le numéro de téléphone doit contenir au moins 10 chiffres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      children: [
        const Text(
          'Sécurité du compte',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Obx(
          () => TextFormField(
            controller: _passwordController,
            obscureText: _authController.obscurePassword.value,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _authController.obscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => _authController.togglePasswordVisibility(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un mot de passe';
              }
              if (value.length < 8) {
                return 'Le mot de passe doit contenir au moins 8 caractères';
              }
              
              
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => TextFormField(
            controller: _confirmPasswordController,
            obscureText: _authController.obscureConfirmPassword.value,
            decoration: InputDecoration(
              labelText: 'Confirmer le mot de passe',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _authController.obscureConfirmPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed:
                    () => _authController.toggleConfirmPasswordVisibility(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer votre mot de passe';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep.value > 0)
            TextButton(
              onPressed: () => _currentStep.value--,
              child: const Text('Retour'),
            )
          else
            const SizedBox(width: 80),
          ElevatedButton(
            onPressed:
                _authController.isLoading
                    ? null
                    : () {
                      if (_formKey.currentState!.validate()) {
                        if (_currentStep.value < 2) {
                          _currentStep.value++;
                        } else {
                          if (_authController.profileImage.value == null) {
                            Get.snackbar(
                              'Erreur',
                              'Veuillez ajouter une photo de profil',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          _authController.signUpParticular(
                            email: _emailController.text,
                            password: _passwordController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phone: _phoneController.text,
                            profileImage: _authController.profileImage.value,
                          );
                        }
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child:
                _authController.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      _currentStep.value < 2 ? 'Suivant' : 'Créer mon compte',
                    ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // En-tête
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Inscription Particulier',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Indicateur d'étapes
                  _buildStepIndicator(),
                  const SizedBox(height: 32),
                  // Contenu de l'étape
                  _buildStepContent(),
                  const SizedBox(height: 32),
                  // Boutons de navigation
                  _buildNavigationButtons(),
                  const SizedBox(height: 16),
                  // Lien de connexion
                  if (_currentStep.value == 0)
                    TextButton(
                      onPressed: () => Get.offAllNamed('/login'),
                      child: const Text('Déjà un compte ? Se connecter'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
