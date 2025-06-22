import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../../core/constants/service_categories.dart';
import '../../core/constants/mali_addresses.dart';

class RegisterProfessionalPage extends StatelessWidget {
  RegisterProfessionalPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _currentStep = 0.obs;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _otherServiceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _selectedCategories = <String>[].obs;
  final _selectedRegion = ''.obs;
  final _selectedCommune = ''.obs;
  final _selectedQuartier = ''.obs;
  final _showOtherServiceField = false.obs;
  final _profileImage = Rx<File?>(null);
  final _isStepValid = false.obs;
  final _authController = Get.find<AuthController>();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      _profileImage.value = File(image.path);
      _validateCurrentStep();
    }
  }

  void _validateCurrentStep() {
    switch (_currentStep.value) {
      case 0:
        _isStepValid.value =
            _emailController.text.isNotEmpty &&
            GetUtils.isEmail(_emailController.text) &&
            _phoneController.text.isNotEmpty;
        break;
      case 1:
        _isStepValid.value =
            _companyNameController.text.isNotEmpty &&
            _selectedCategories.isNotEmpty &&
            _selectedRegion.value.isNotEmpty &&
            _selectedCommune.value.isNotEmpty &&
            _selectedQuartier.value.isNotEmpty &&
            (!_showOtherServiceField.value ||
                _otherServiceController.text.isNotEmpty);
        break;
      case 2:
        _isStepValid.value =
            _passwordController.text.length >= 6 &&
            _passwordController.text == _confirmPasswordController.text;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Inscription Professionnel'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indicateur de progression
              Obx(
                () => LinearProgressIndicator(
                  value: (_currentStep.value + 1) / 3,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              // Étapes
              Obx(
                () => Text(
                  'Étape ${_currentStep.value + 1} sur 3',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // Formulaire
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Obx(() {
                    switch (_currentStep.value) {
                      case 0:
                        return _buildAccountInfoStep();
                      case 1:
                        return _buildServiceInfoStep();
                      case 2:
                        return _buildPasswordStep();
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Informations du compte',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          // Photo de profil
          Center(
            child: Stack(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _profileImage.value != null
                            ? FileImage(_profileImage.value!)
                            : null,
                    child:
                        _profileImage.value == null
                            ? const Icon(
                              Icons.person_outline,
                              size: 60,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => _validateCurrentStep(),
            decoration: InputDecoration(
              labelText: 'Email professionnel',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
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
            onChanged: (_) => _validateCurrentStep(),
            decoration: InputDecoration(
              labelText: 'Téléphone',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre numéro de téléphone';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          Obx(
            () => ElevatedButton(
              onPressed:
                  _isStepValid.value
                      ? () {
                        if (_formKey.currentState!.validate()) {
                          _currentStep.value++;
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Suivant',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Informations du service',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _companyNameController,
            onChanged: (_) => _validateCurrentStep(),
            decoration: InputDecoration(
              labelText: 'Nom de l\'entreprise',
              prefixIcon: const Icon(Icons.business_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nom de l\'entreprise';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Catégories de services',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  ServiceCategories.categories.map((category) {
                    final isSelected = _selectedCategories.contains(
                      category.id,
                    );
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(category.icon),
                          const SizedBox(width: 4),
                          Text(category.name),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _selectedCategories.add(category.id);
                          if (category.id == 'other') {
                            _showOtherServiceField.value = true;
                          }
                        } else {
                          _selectedCategories.remove(category.id);
                          if (category.id == 'other') {
                            _showOtherServiceField.value = false;
                            _otherServiceController.clear();
                          }
                        }
                        _validateCurrentStep();
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: Colors.black.withOpacity(0.1),
                      checkmarkColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.black : Colors.grey[300]!,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () =>
                _showOtherServiceField.value
                    ? TextFormField(
                      controller: _otherServiceController,
                      onChanged: (_) => _validateCurrentStep(),
                      decoration: InputDecoration(
                        labelText: 'Précisez votre service',
                        prefixIcon: const Icon(Icons.add_business_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (_showOtherServiceField.value &&
                            (value == null || value.isEmpty)) {
                          return 'Veuillez préciser votre service';
                        }
                        return null;
                      },
                    )
                    : const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Adresse',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Région
          Obx(
            () => DropdownButtonFormField<String>(
              value:
                  _selectedRegion.value.isEmpty ? null : _selectedRegion.value,
              decoration: InputDecoration(
                labelText: 'Région',
                prefixIcon: const Icon(Icons.location_city_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                ),
              ),
              items:
                  MaliAddresses.regions
                      .map(
                        (region) => DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  _selectedRegion.value = value;
                  _selectedCommune.value = '';
                  _selectedQuartier.value = '';
                  _validateCurrentStep();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une région';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          // Commune
          Obx(
            () => DropdownButtonFormField<String>(
              value:
                  _selectedCommune.value.isEmpty
                      ? null
                      : _selectedCommune.value,
              decoration: InputDecoration(
                labelText: 'Commune',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                ),
              ),
              items:
                  _selectedRegion.value.isEmpty
                      ? []
                      : MaliAddresses.getCommunes(_selectedRegion.value)
                          .map(
                            (commune) => DropdownMenuItem(
                              value: commune,
                              child: Text(commune),
                            ),
                          )
                          .toList(),
              onChanged:
                  _selectedRegion.value.isEmpty
                      ? null
                      : (value) {
                        if (value != null) {
                          _selectedCommune.value = value;
                          _selectedQuartier.value = '';
                          _validateCurrentStep();
                        }
                      },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner une commune';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          // Quartier
          Obx(
            () => DropdownButtonFormField<String>(
              value:
                  _selectedQuartier.value.isEmpty
                      ? null
                      : _selectedQuartier.value,
              decoration: InputDecoration(
                labelText: 'Quartier',
                prefixIcon: const Icon(Icons.home_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                ),
              ),
              items:
                  (_selectedRegion.value.isEmpty ||
                          _selectedCommune.value.isEmpty)
                      ? []
                      : MaliAddresses.getQuartiers(
                            _selectedRegion.value,
                            _selectedCommune.value,
                          )
                          .map(
                            (quartier) => DropdownMenuItem(
                              value: quartier,
                              child: Text(quartier),
                            ),
                          )
                          .toList(),
              onChanged:
                  (_selectedRegion.value.isEmpty ||
                          _selectedCommune.value.isEmpty)
                      ? null
                      : (value) {
                        if (value != null) {
                          _selectedQuartier.value = value;
                          _validateCurrentStep();
                        }
                      },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner un quartier';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _currentStep.value--,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Précédent'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        _isStepValid.value
                            ? () {
                              if (_formKey.currentState!.validate()) {
                                _currentStep.value++;
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Suivant'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sécurité du compte',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (_) => _validateCurrentStep(),
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un mot de passe';
              }
              if (value.length < 6) {
                return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            onChanged: (_) => _validateCurrentStep(),
            decoration: InputDecoration(
              labelText: 'Confirmer le mot de passe',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer le mot de passe';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _currentStep.value--,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Précédent'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        _authController.isLoading || !_isStepValid.value
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                final categories = _selectedCategories
                                    .map((id) {
                                      if (id == 'other') {
                                        return _otherServiceController.text;
                                      }
                                      return ServiceCategories.categories
                                          .firstWhere((c) => c.id == id)
                                          .name;
                                    })
                                    .join(', ');
                                _authController.signUpProfessional(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  companyName: _companyNameController.text,
                                  activity: categories,
                                  address:
                                      '${_selectedQuartier.value}, ${_selectedCommune.value}, ${_selectedRegion.value}',
                                  phone: _phoneController.text,
                                  profileImage: _profileImage.value,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text('Créer mon compte'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
