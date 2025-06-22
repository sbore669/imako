class MaliAddress {
  final String region;
  final String commune;
  final String quartier;

  const MaliAddress({
    required this.region,
    required this.commune,
    required this.quartier,
  });
}

class MaliAddresses {
  static const List<MaliAddress> addresses = [
    // Bamako
        // Commune I – 9 quartiers
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Banconi'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Boulkassoumbougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Djélibougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Doumanzana'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Fadjiguila'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Sotuba'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Korofina Nord'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Korofina Sud'),
    MaliAddress(region: 'Bamako', commune: 'Commune I', quartier: 'Sikoroni'),

    // Commune II – 11 quartiers
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Niaréla'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Bagadadji'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Médina‑Coura'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Bozola'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Missira'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Hippodrome'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Quinzambougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Bakaribougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'TSF'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Zone Industrielle'),
    MaliAddress(region: 'Bamako', commune: 'Commune II', quartier: 'Bougouba'),

    // Commune III – 20 quartiers
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'N’Tomikorobougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Dar Salam'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Bolibana'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'ACI‑2000'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Centre commercial'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Koulouba'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Point G'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Koulouninko'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Sirakoro‑Dounfing'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Ouolofobougou‑Bolibana'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Bamako‑Coura'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Badialan I'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Badialan II'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Badialan III'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Dravela'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Dravela‑Bolibana'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Niominanbougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Sogonafing'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Samé'),
    MaliAddress(region: 'Bamako', commune: 'Commune III', quartier: 'Kodabougou'),

    // Commune IV – 8 quartiers
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Taliko'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Lassa'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Sibiribougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Djikoroni‑Para'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Sébénikoro'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Hamdallaye'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Lafiabougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune IV', quartier: 'Kalabambougou'),

    // Commune V – 8 quartiers
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Badalabougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Sema I'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Quartier Mali'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Torokorobougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Baco‑Djicoroni'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Sabalibougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Daoudabougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune V', quartier: 'Kalaban‑Coura'),

    // Commune VI – 10 quartiers
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Banankabougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Djanékéla'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Faladié'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Magnambougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Missabougou'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Niamakoro'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Sénou'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Sogoniko'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Sokorodji'),
    MaliAddress(region: 'Bamako', commune: 'Commune VI', quartier: 'Yirimadio'),

    // Koulikoro
    MaliAddress(region: 'Koulikoro', commune: 'Koulikoro', quartier: 'Centre'),
    MaliAddress(
      region: 'Koulikoro',
      commune: 'Koulikoro',
      quartier: 'Sirakoro',
    ),

    // Sikasso
    MaliAddress(region: 'Sikasso', commune: 'Sikasso', quartier: 'Centre'),
    MaliAddress(region: 'Sikasso', commune: 'Sikasso', quartier: 'Bougoula'),

    // Ségou
    MaliAddress(region: 'Ségou', commune: 'Ségou', quartier: 'Centre'),
    MaliAddress(
      region: 'Ségou',
      commune: 'Ségou',
      quartier: 'Quartier Mission',
    ),

    // Mopti
    MaliAddress(region: 'Mopti', commune: 'Mopti', quartier: 'Centre'),
    MaliAddress(region: 'Mopti', commune: 'Mopti', quartier: 'Sévaré'),

    // Tombouctou
    MaliAddress(
      region: 'Tombouctou',
      commune: 'Tombouctou',
      quartier: 'Centre',
    ),
    MaliAddress(
      region: 'Tombouctou',
      commune: 'Tombouctou',
      quartier: 'Abaradjou',
    ),

    // Gao
    MaliAddress(region: 'Gao', commune: 'Gao', quartier: 'Centre'),
    MaliAddress(region: 'Gao', commune: 'Gao', quartier: 'Sonni Ali Ber'),

    // Kidal
    MaliAddress(region: 'Kidal', commune: 'Kidal', quartier: 'Centre'),
    MaliAddress(region: 'Kidal', commune: 'Kidal', quartier: 'Essouk'),
  ];

  static List<String> get regions =>
      addresses.map((a) => a.region).toSet().toList();

  static List<String> getCommunes(String region) {
    return addresses
        .where((a) => a.region == region)
        .map((a) => a.commune)
        .toSet()
        .toList();
  }

  static List<String> getQuartiers(String region, String commune) {
    return addresses
        .where((a) => a.region == region && a.commune == commune)
        .map((a) => a.quartier)
        .toList();
  }
}
