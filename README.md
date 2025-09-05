# Kora Expense Tracker

A comprehensive personal finance tracker app built with Flutter, designed to be user-friendly for beginners while offering powerful features that rival top fintech companies. The app focuses on credit card management with multi-currency support, defaulting to INR (Indian Rupee), then USD and other currencies.

## 🚀 Features

### Core Features
- **Multi-Currency Support**: Defaults to INR, supports USD and other currencies
- **Credit Card Management**: Complete CRUD operations for credit cards
- **Transaction Management**: Add, edit, view, and categorize transactions
- **Account Management**: Manage multiple bank accounts and wallets
- **Dashboard**: Real-time financial overview with quick stats
- **Analytics**: Deep analytical insights and reports
- **Dark/Light Theme**: Beautiful UI with theme switching

### Advanced Features (Planned)
- **SMS Parsing**: Auto-parse transaction data from SMS
- **Smart Notifications**: Intelligent reminders for payments
- **Currency Conversion**: Real-time exchange rates
- **Data Export**: Export transactions and reports

## 📱 Screenshots

*Screenshots will be added once the UI is fully implemented*

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Entry point: initialize app, providers, error handling
├── core/                             # Core functionality
│   ├── constants/                    # App-wide constants
│   │   ├── colors/                  # Color definitions
│   │   ├── strings/                 # String constants and categories
│   │   └── enums/                   # App enums
│   ├── errors/                      # Error handling system
│   │   ├── exceptions/              # Custom exception classes
│   │   └── handlers/                # Global error handlers
│   ├── services/                    # Core services
│   │   └── database/                # SQLite database service
│   └── theme/                       # App theming
├── features/                        # Feature-based modules
│   ├── dashboard/                   # Dashboard feature
│   │   ├── screens/                 # Dashboard screens
│   │   └── widgets/                 # Dashboard widgets
│   ├── transactions/                # Transaction management
│   │   └── screens/                 # Transaction screens
│   ├── accounts/                    # Account management
│   │   └── screens/                 # Account screens
│   ├── credit_cards/                # Credit card management
│   │   └── screens/                 # Credit card screens
│   ├── analytics/                   # Analytics and reports
│   │   └── screens/                 # Analytics screens
│   ├── settings/                    # Settings and preferences
│   │   └── screens/                 # Settings screens
│   └── onboarding/                  # User onboarding
│       └── screens/                 # Onboarding screens
├── shared/                          # Shared components
│   ├── models/                      # Data models
│   │   ├── transaction.dart         # Transaction data structure
│   │   ├── account.dart             # Account data structure
│   │   └── credit_card.dart         # Credit card data structure
│   └── providers/                   # State management
│       └── app_provider.dart        # App-wide state management
└── widgets/                         # Reusable UI components
    └── common/                      # Common widgets
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.16.0
- **Language**: Dart 3.2.0
- **State Management**: Flutter Riverpod
- **Database**: SQLite (sqflite)
- **Local Storage**: Hive
- **Charts**: FL Chart
- **Currency**: Money2
- **Notifications**: Flutter Local Notifications
- **Permissions**: Permission Handler
- **HTTP**: Dio
- **Image Picker**: Image Picker
- **Preferences**: Shared Preferences

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `sqflite`: SQLite database
- `path`: File path utilities
- `hive`: Local storage
- `hive_flutter`: Hive Flutter integration

### UI Dependencies
- `fl_chart`: Beautiful charts
- `cupertino_icons`: iOS-style icons
- `intl`: Internationalization

### Utility Dependencies
- `money2`: Currency handling
- `equatable`: Value equality
- `uuid`: Unique identifiers
- `dio`: HTTP client
- `image_picker`: Image selection
- `shared_preferences`: Key-value storage
- `permission_handler`: Runtime permissions
- `flutter_local_notifications`: Local notifications
- `url_launcher`: URL launching
- `xml`: XML parsing

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/kora-expense-tracker.git
   cd kora-expense-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🎨 Design Principles

### User-Friendly First
- Intuitive navigation with full-page screens (no popups)
- Clear visual hierarchy and consistent theming
- Beginner-friendly with inline comments throughout codebase
- Comprehensive error handling with user-friendly messages

### Power User Features
- Advanced analytics and reporting
- Multi-currency support with real-time conversion
- Comprehensive CRUD operations with immediate global updates
- Revert mechanisms for all operations (especially credit cards)
- Scalable architecture for future enhancements

## 🔧 Development Guidelines

### Code Organization
- Feature-based folder structure for scalability
- Comprehensive inline comments for beginners
- Consistent naming conventions
- Proper error handling and logging

### State Management
- Immediate UI updates on data changes
- Global state management with Riverpod
- Proper separation of concerns

### Database
- SQLite for local storage
- Optimized queries for performance
- Proper data validation and constraints

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 11.0+)
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- The open-source community for various packages
- Design inspiration from top fintech apps

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/kora-expense-tracker/issues) page
2. Create a new issue with detailed information
3. Contact the development team

## 🗺️ Roadmap

### Phase 1 (Current)
- ✅ Basic app structure and navigation
- ✅ Core models and database setup
- ✅ Dashboard and transaction screens
- ✅ Theme system and error handling

### Phase 2 (Next)
- 🔄 Credit card management screens
- 🔄 Account management screens
- 🔄 Analytics and reports
- 🔄 Currency service implementation

### Phase 3 (Future)
- 📋 SMS parsing functionality
- 📋 Advanced notifications
- 📋 Data export features
- 📋 Cloud sync capabilities

---

**Built with ❤️ using Flutter**