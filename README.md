# PULSE — Space Health Anomaly Detection System

**PULSE** is a 100% offline-first Flutter application designed for astronauts operating in microgravity environments. Developed for the NASA Space Apps Challenge, PULSE monitors vital telemetry, detects physiological anomalies, and provides immediate, reliable text-to-speech (TTS) voice feedback—all without requiring an active internet connection.

---

## Key Features

- **Microgravity-Optimized UI/UX**: Portrait-first mobile layout with adaptive support, large touch targets, and low-friction ergonomics designed for floating/microgravity use.
- **100% Offline Architecture**: Zero cloud dependencies to ensure operational reliability during deep-space communications blackouts.
- **Voice Feedback Engine**: Instant offline speech feedback integrated via Riverpod for critical notifications, alerts, and navigation actions.
- **Local Telemetry Store**: On-device SQLite measurements via Drift, with dashboard stats, indicator history, and a risk detector over blood, urine, tracker, and eye-health biomarkers.

---

## Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Riverpod 3.x](https://riverpod.dev)
- **Local Database**: [Drift](https://drift.simonbinder.eu) (SQLite)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Audio / TTS**: `flutter_tts` (configured with deterministic offline initialization)
- **Design System**: Custom dark-theme Sci-Fi palette with high-contrast UI components

### Project Structure

```text
lib/
├── common/             # Shared UI widgets (Navigation Bars)
│   ├── models/
│   └── widgets/
├── core/               # App-wide infrastructure
│   ├── database/       # Drift schema, providers, metric registry
│   ├── risk_detector/  # Physiological risk rules
│   └── tts/            # Offline TTS service and Riverpod provider wrapper
├── features/           # Feature-based domain modules
│   ├── add_metrics/
│   ├── dashboard/
│   ├── debug/
│   └── indicators/
└── theme/              # Colors, sizes, and Material theme
```

---

## Getting Started

### Prerequisites

- **Flutter SDK**: stable channel
- **Dart SDK**: `^3.13.5` or higher
- **Android Studio / Xcode** (for device deployment and native bindings)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/cherenov/pulse.git
   cd pulse
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

---

## Contributing & Git Workflow

We follow a lightweight **GitHub Flow** branching model. Direct commits to `main` are restricted to maintain core stability.

### Branch Conventions

- `setup/` or `chore/` — Project foundation, dependencies, and core configuration (`setup/core-architecture`).
- `feature/` — New end-user features or screens (`feature/dashboard`).
- `fix/` — Bug fixes and crash resolutions (`fix/tts-android-init`).
- `refactor/` — Internal code restructuring without behavioral changes.

### Development Steps

1. Pull the latest state from `main`:
   ```bash
   git checkout main
   git pull origin main
   ```
2. Create your working branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes and push to GitHub:
   ```bash
   git push origin feature/your-feature-name
   ```
4. Open a **Pull Request (PR)** targeting `main` and request a review from the Lead Architect.

---

## License

Copyright 2026 PULSE Team

Licensed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0).
See the `LICENSE` file in the repository for the full terms.
