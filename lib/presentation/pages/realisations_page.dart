import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:imako_app/presentation/controllers/realisation_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:imako_app/presentation/pages/fullscreen_media_viewer.dart';
import 'package:imako_app/presentation/pages/details_profile_professionnel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RealisationsPage extends StatefulWidget {
  RealisationsPage({super.key});

  @override
  State<RealisationsPage> createState() => _RealisationsPageState();
}

class _RealisationsPageState extends State<RealisationsPage> {
  final RealisationController _realisationController =
      Get.put(RealisationController());
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
            'Erreur', 'Impossible de trouver l\'application WhatsApp.');
      }
    } on PlatformException catch (e) {
      Get.snackbar('Erreur de plateforme',
          'Impossible d\'ouvrir WhatsApp. Assurez-vous que l\'application est installée.');
    } catch (e) {
      Get.snackbar('Erreur inattendue', 'Une erreur est survenue.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser;
    final isProfessional = currentUser != null &&
        currentUser.userType.toString().contains('professional');
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo à gauche
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Image.asset(
                        'assets/logo/logo_icons.png',
                        width: 34,
                        height: 34,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Titre ou barre de recherche au centre
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: _showSearch
                            ? Container(
                                key: const ValueKey('search'),
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher...',
                                    prefixIcon: const Icon(Icons.search,
                                        color: Color(0xFF64748B), size: 22),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      _showSearch = false;
                                    });
                                  },
                                ),
                              )
                            : Center(
                                key: const ValueKey('title'),
                                child: Text(
                                  'Réalisations',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Icône de recherche à droite
                    IconButton(
                      icon: Icon(_showSearch ? Icons.close : Icons.search,
                          color: const Color(0xFF64748B)),
                      onPressed: () {
                        setState(() {
                          _showSearch = !_showSearch;
                          if (!_showSearch) _searchController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (_realisationController.isLoading.value &&
                  _realisationController.realisations.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (_realisationController.realisations.isEmpty) {
                return const SliverFillRemaining(
                  child:
                      Center(child: Text("Aucune réalisation pour le moment.")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final realisation =
                        _realisationController.realisations[index];
                    // Formatter la date pour l'affichage "Il y a X"
                    final timeAgoString = timeago
                        .format(realisation.createdAt.toDate(), locale: 'fr');

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 6),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header du post
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 12, 10, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigation vers la page de détails du professionnel
                                      Get.to(() => DetailsProfileProfessionnel(
                                            professionalId:
                                                realisation.professionalId,
                                          ));
                                    },
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: const Color(0xFFF1F5F9),
                                      backgroundImage: (realisation
                                                      .professionalProfileImageUrl !=
                                                  null &&
                                              realisation
                                                  .professionalProfileImageUrl!
                                                  .isNotEmpty)
                                          ? NetworkImage(realisation
                                              .professionalProfileImageUrl!)
                                          : null,
                                      child: (realisation
                                                      .professionalProfileImageUrl ==
                                                  null ||
                                              realisation
                                                  .professionalProfileImageUrl!
                                                  .isEmpty)
                                          ? Text(
                                              realisation.professionalName
                                                      .isNotEmpty
                                                  ? realisation
                                                      .professionalName[0]
                                                  : 'P',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                                fontSize: 20,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigation vers la page de détails du professionnel
                                        Get.to(
                                            () => DetailsProfileProfessionnel(
                                                  professionalId: realisation
                                                      .professionalId,
                                                ));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                realisation.professionalName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color(0xFF0F172A),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '· ${realisation.title}',
                                                style: const TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                timeAgoString,
                                                style: const TextStyle(
                                                  color: Color(0xFF94A3B8),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(Icons.public,
                                                  size: 13,
                                                  color: Color(0xFFB0B8C1)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.more_horiz,
                                        color: Color(0xFF64748B)),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                            // Carrousel d'images
                            if (realisation.mediaUrls.isNotEmpty)
                              _ImageCarousel(images: realisation.mediaUrls),
                            // Description
                            if (realisation.description.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 0),
                                child: Text(
                                  realisation.description,
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xFF334155)),
                                ),
                              ),
                            // Actions (like, commentaire, WhatsApp)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                              child: Row(
                                children: [
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF64748B),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {},
                                    icon: const Text('👍🏼',
                                        style: TextStyle(fontSize: 18)),
                                    label: Text('${realisation.likes}'),
                                  ),
                                  const SizedBox(width: 2),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF64748B),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {},
                                    icon: const Text('💬',
                                        style: TextStyle(fontSize: 18)),
                                    label: Text('${realisation.comments}'),
                                  ),
                                  const Spacer(),
                                  if (realisation.whatsappNumber != null &&
                                      realisation.whatsappNumber!.isNotEmpty)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF25D366),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.transparent,
                                          minimumSize: const Size(120, 44),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          elevation: 0,
                                        ),
                                        onPressed: () => _launchWhatsApp(
                                            realisation.whatsappNumber!),
                                        icon: const FaIcon(
                                            FontAwesomeIcons.whatsapp,
                                            size: 22),
                                        label: const Text('WhatsApp'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _realisationController.realisations.length,
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: isProfessional
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _CreateRealisationModal(),
                );
              },
              backgroundColor: const Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              elevation: 8,
              splashColor: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tooltip: 'Publier une réalisation',
              child: const Icon(Icons.add_rounded, size: 30),
            )
          : null,
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> images;
  const _ImageCarousel({required this.images});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullscreenMediaViewer(
                        mediaUrls: widget.images,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: widget.images[index],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      widget.images[index],
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      // Gérer le chargement et les erreurs
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 220,
                          color: Colors.grey[200],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 220,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image,
                              size: 50, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _current == i ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _current == i
                        ? const Color(0xFF64748B)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CreateRealisationModal extends StatefulWidget {
  @override
  State<_CreateRealisationModal> createState() =>
      _CreateRealisationModalState();
}

class _CreateRealisationModalState extends State<_CreateRealisationModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final List<XFile> _mediaFiles = [];
  bool _addWhatsApp = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final List<XFile> pickedFiles = await _picker.pickMultipleMedia();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _mediaFiles.addAll(pickedFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser;
    final String displayName =
        user?.companyName ?? user?.firstName ?? 'Professionnel';
    final String? profileImageUrl = user?.profileImageUrl;
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P';

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Créer une publication',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Divider(height: 1),
            // User info and text field
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFF1F5F9),
                              backgroundImage: (profileImageUrl != null &&
                                      profileImageUrl.isNotEmpty)
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                              child: (profileImageUrl == null ||
                                      profileImageUrl.isEmpty)
                                  ? Text(initial,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Color(0xFF64748B)))
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Text(displayName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Champ Titre redessiné
                        TextFormField(
                          controller: _titleController,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Titre',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Veuillez ajouter un titre.'
                              : null,
                        ),
                        // Champ Description redessiné
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 5,
                          maxLines: 10,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87, height: 1.5),
                          decoration: InputDecoration(
                            hintText:
                                'Racontez-en plus sur votre réalisation...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 16, color: Colors.grey[400]),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        // Media Grid
                        if (_mediaFiles.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _mediaFiles.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              // TODO: Gérer l'affichage video/image
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFE2E8F0)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(_mediaFiles[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _mediaFiles.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Actions
            const Divider(height: 1),
            // Section contact WhatsApp
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile(
                title: const Text('Ajouter un contact WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                value: _addWhatsApp,
                onChanged: (bool value) {
                  setState(() {
                    _addWhatsApp = value;
                  });
                },
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (_addWhatsApp)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextFormField(
                  controller: _whatsappController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Numéro WhatsApp (ex: 223xxxxxx)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            // Barre d'outils avec texte et icônes
            Container(
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _pickMedia,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 14.0),
                    child: Row(
                      children: [
                        const Text(
                          'Ajouter photo/vidéo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.photo_library_outlined,
                            color: Colors.black54, size: 24),
                        const SizedBox(width: 16),
                        const Icon(Icons.videocam_outlined,
                            color: Colors.black54, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Publier button section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_titleController.text.trim().isEmpty &&
                          _mediaFiles.isEmpty)
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            Get.find<RealisationController>().createRealisation(
                              description: _descriptionController.text,
                              title: _titleController.text,
                              mediaFiles: _mediaFiles,
                              whatsappNumber: _addWhatsApp
                                  ? _whatsappController.text
                                  : null,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                  ),
                  child: const Text('Publier'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipOption(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label:
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.blue)),
      backgroundColor: const Color(0xFFEFF6FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color) {
    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: () {
        // TODO: Action spécifique à chaque bouton
      },
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
