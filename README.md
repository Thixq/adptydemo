# Adapty Flutter Demo 📱

A robust Flutter demonstration project showcasing the integration of [Adapty.io](https://adapty.io/) for in-app subscriptions and paywalls. This project serves as a reference implementation for handling purchases, premium status management, and environment setup in a clean architecture.

## 🌟 Features

- **Adapty Integration**: Complete implementation of Adapty SDK using a dedicated `AdaptyManager` service.
- **StoreKit Testing**: configured with a local `.storekit` file for easy iOS subscription testing without a real Sandbox account.
- **State Management**: Uses `ValueNotifier` for reactive premium status updates.
- **Dependency Injection**: Clean service location using `get_it`.
- **Local Storage**: Persists user data locally using `hive`.
- **Environment Security**: API keys managed securely using `envied`.
- **Unit Testing**: Comprehensive tests for the `AdaptyManager` logic.

## 🎥 Preview

You can find a preview video of the application in the assets folder:
`assets/app_preview.mp4`

## 🛠️ Tech Stack

- **Framework**: Flutter
- **In-App Purchases**: [adapty_flutter](https://pub.dev/packages/adapty_flutter)
- **DI**: [get_it](https://pub.dev/packages/get_it)
- **Storage**: [hive](https://pub.dev/packages/hive)
- **Secrets**: [envied](https://pub.dev/packages/envied)
- **Testing**: [mockito](https://pub.dev/packages/mockito)

## 📂 Project Structure

```
lib/
├── component/              # UI widgets (Paywalls, Cards, BottomSheets)
├── env/                    # Environment configuration (Envied)
├── model/                  # Data models (Note, UserProfile)
├── page/                   # Application screens
├── service_and_managers/   # Core business logic
│   ├── adapty_manager.dart # Main Adapty wrapper service
│   └── ...
├── locator.dart            # DI setup
└── main.dart               # Entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.9.0

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/adptydemo.git
   cd adptydemo
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Environment Variables:**
   This project uses `envied` to hide sensitive keys. You need to create your `.env` file in `assets/env/` (referenced in `lib/env/dev_env.dart`) and then run the generator:
   ```bash
   dart run build_runner build -d
   ```

4. **Run the App:**
   ```bash
   flutter run
   ```

## 🍎 iOS StoreKit Testing

This project is configured to use a local StoreKit configuration file for testing in-app purchases on the iOS Simulator.

1. Open `ios/Runner.xcworkspace` in Xcode.
2. The project uses `ios/Runner/Thixq Adapty Demo.storekit`.
3. To enable it:
   - Go to **Product > Scheme > Edit Scheme**.
   - Select **Run** on the left sidebar.
   - Under the **Options** tab, set **StoreKit Configuration** to `Thixq Adapty Demo`.
   
This allows you to simulate purchase flows, renewals, and cancellations directly on the simulator without connecting to App Store Connect.

## 🧪 Testing

Unit tests are included for the core logic, specifically the `AdaptyManager`.

To run the tests:

```bash
flutter test
```

## 📝 License

This project is open source and available under the [MIT License](LICENSE).
