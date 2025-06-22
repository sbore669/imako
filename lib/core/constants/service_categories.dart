class ServiceCategory {
  final String id;
  final String name;
  final String icon;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class ServiceCategories {
  static const List<ServiceCategory> categories = [
    // Maison & Entretien
    ServiceCategory(id: 'cleaning', name: 'Nettoyage', icon: '🧹'),
    ServiceCategory(id: 'gardening', name: 'Jardinage', icon: '🌳'),
    ServiceCategory(id: 'plumbing', name: 'Plomberie', icon: '🔧'),
    ServiceCategory(id: 'electrical', name: 'Électricité', icon: '⚡'),
    ServiceCategory(id: 'painting', name: 'Peinture', icon: '🎨'),
    ServiceCategory(id: 'carpentry', name: 'Menuiserie', icon: '🪚'),
    ServiceCategory(id: 'moving', name: 'Déménagement', icon: '📦'),
    ServiceCategory(id: 'handyman', name: 'Bricolage & Réparations', icon: '🛠️'),
    ServiceCategory(id: 'pest_control', name: 'Dératisation & Désinsectisation', icon: '🐜'),
    ServiceCategory(id: 'home_automation', name: 'Domotique & Smart Home', icon: '🏡'),

    // Vie quotidienne
    ServiceCategory(id: 'cooking', name: 'Cuisine à domicile', icon: '👨‍🍳'),
    ServiceCategory(id: 'childcare', name: 'Garde d\'enfants', icon: '👶'),
    ServiceCategory(id: 'elderly_care', name: 'Aide aux personnes âgées', icon: '👴'),
    ServiceCategory(id: 'pet_care', name: 'Garde d\'animaux', icon: '🐾'),
    ServiceCategory(id: 'beauty', name: 'Beauté & Bien-être', icon: '💅'),
    ServiceCategory(id: 'massage', name: 'Massage & Thérapie', icon: '💆'),
    ServiceCategory(id: 'fitness', name: 'Coach sportif & Fitness', icon: '🏋️'),

    // Éducation & culture
    ServiceCategory(id: 'education', name: 'Cours particuliers', icon: '📚'),
    ServiceCategory(id: 'language', name: 'Cours de langues', icon: '🗣️'),
    ServiceCategory(id: 'music', name: 'Cours de musique', icon: '🎸'),
    ServiceCategory(id: 'art', name: 'Cours d\'art & dessin', icon: '🖌️'),

    // Technologie & Digital
    ServiceCategory(id: 'it', name: 'Informatique & Assistance', icon: '💻'),
    ServiceCategory(id: 'graphic_design', name: 'Design graphique', icon: '🎨'),
    ServiceCategory(id: 'web_dev', name: 'Développement web & apps', icon: '🌐'),
    ServiceCategory(id: 'social_media', name: 'Réseaux sociaux & Community management', icon: '📱'),
    ServiceCategory(id: 'photo_video', name: 'Photo & Vidéo', icon: '📷'),

    // Mobilité
    ServiceCategory(id: 'mechanic', name: 'Réparation automobile', icon: '🚗'),
    ServiceCategory(id: 'chauffeur', name: 'Chauffeur privé', icon: '🚘'),
    ServiceCategory(id: 'bike_repair', name: 'Réparation de vélos & motos', icon: '🛵'),
    ServiceCategory(id: 'transport', name: 'Transport & Livraison', icon: '🚚'),

    // Administratif & Professionnel
    ServiceCategory(id: 'translation', name: 'Traduction & Rédaction', icon: '📝'),
    ServiceCategory(id: 'legal', name: 'Assistance juridique', icon: '⚖️'),
    ServiceCategory(id: 'finance', name: 'Comptabilité & Finance', icon: '💰'),
    ServiceCategory(id: 'real_estate', name: 'Services immobiliers', icon: '🏠'),
    ServiceCategory(id: 'events', name: 'Organisation d\'événements', icon: '🎉'),
    ServiceCategory(id: 'security', name: 'Sécurité & Surveillance', icon: '🛡️'),

    // Artisanat & Création
    ServiceCategory(id: 'tailoring', name: 'Couture & Retouches', icon: '🧵'),
    ServiceCategory(id: 'shoemaker', name: 'Cordonnier / Réparation de chaussures', icon: '👞'),
    ServiceCategory(id: 'craft', name: 'Artisanat & Fabrication sur mesure', icon: '🪡'),

    // Autres
    ServiceCategory(id: 'spiritual', name: 'Services spirituels / religieux', icon: '🕊️'),
    ServiceCategory(id: 'funeral', name: 'Services funéraires', icon: '⚰️'),
    ServiceCategory(id: 'consulting', name: 'Conseil & Coaching', icon: '🧠'),
    ServiceCategory(id: 'other', name: 'Autre', icon: '➕'),
  ];
}

