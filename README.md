# 🌱 Smart Irrigation App

Application mobile Flutter de contrôle d'irrigation automatique avec simulation de capteurs.

## Fonctionnalités

- **Dashboard** — Capteurs en temps réel (humidité, température, sol) + contrôle manuel ON/OFF
- **Schedule** — Planification avec jours/heure/durée, activation/désactivation, suppression
- **History** — Graphiques des capteurs (fl_chart) + historique des événements d'irrigation

## Stack technique

- Flutter 3.x / Dart 3.x
- `provider` — gestion d'état
- `fl_chart` — graphiques
- `shared_preferences` — persistance locale
- `intl` — formatage dates

## Installation

```bash
# 1. Cloner / copier le projet
cd irrigation_app

# 2. Installer les dépendances
flutter pub get

# 3. Lancer sur simulateur ou appareil
flutter run

# 4. Build APK
flutter build apk --release
```

## Structure du projet

```
lib/
├── main.dart                      # Entry point + navigation
├── models/
│   └── models.dart                # SensorData, IrrigationSchedule, IrrigationEvent
├── services/
│   └── irrigation_service.dart    # Logique métier + simulation capteurs (ChangeNotifier)
├── screens/
│   ├── dashboard_screen.dart      # Écran principal
│   ├── schedule_screen.dart       # Gestion des planifications
│   └── history_screen.dart        # Graphiques + historique
└── widgets/
    ├── sensor_card.dart           # Carte capteur avec barre de progression
    ├── control_panel.dart         # Bouton ON/OFF + sélecteur durée + countdown
    └── stat_card.dart             # Carte statistique
```

## Architecture

La simulation tourne via un `Timer.periodic` toutes les 3 secondes dans `IrrigationService`.  
Pour connecter un vrai hardware (ESP32, Arduino) : remplacer la simulation par des appels HTTP/MQTT dans `irrigation_service.dart`.

## Prochaines étapes possibles

- Connexion Firebase pour sync multi-appareils
- Intégration MQTT pour ESP32/Raspberry Pi
- Notifications push lors du démarrage/arrêt
- Alertes si humidité du sol trop basse
- Mode automatique basé sur les capteurs
