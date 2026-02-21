# AI Coding Agent Instructions for Restaurant Management App

## Project Overview
This is a multi-role Flutter restaurant management application with Firebase backend. It serves customers, vendors, staff, chefs, and admins with features for ordering, payments, delivery tracking, and restaurant operations management.

## Architecture & Key Components

### Core Layer Structure
- **Providers** (`lib/providers/`): State management using Provider package - one provider per major feature (auth, cart, orders, wallet, menu, feedback, vendor, user)
- **Services** (`lib/services/`): Firebase/backend integration - handles Firestore, Auth, Messaging, Notifications
- **Models** (`lib/models/`): Data classes with `fromMap()` and `toMap()` for Firestore serialization
- **Screens** (`lib/screens/`): UI organized by user role (auth, admin, chef, vendor, customer features)
- **Widgets** (`lib/widgets/`): Reusable UI components

### Firebase Integration
- **Project**: `restaurent-app-a4dd0` (configured in `firebase_options.dart`)
- **Services Used**: Firebase Auth, Cloud Firestore, Firebase Storage, Firebase Messaging
- **Key Collections**: `users`, `orders`, `menu`, `vendors`, `feedback`, `notifications`
- **Auth Roles**: `admin`, `staff`, `chef`, `user` (defined in `UserRole` enum in auth_provider.dart)

### State Management Pattern
Provider package manages:
- `AuthProvider`: User login/logout, role management, OTP generation
- `CartProvider`: Shopping cart items with user tracking
- `OrderProvider`: Order creation and history
- `MenuProvider`: Menu items and categories
- `VendorProvider`: Vendor listings and details
- `WalletProvider`: User wallet transactions
- `FeedbackProvider`: User feedback/reviews
- `UserProvider`: User profile management
- `ThemeProvider`: Dark/light mode toggle

## Critical Developer Workflows

### Setup & Dependencies
```bash
# Install dependencies
flutter pub get

# Run app with Firebase initialization
flutter run -d <device_id>

# Code generation (if needed for models)
flutter pub run build_runner build
```

### Build for Production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Running Tests
```bash
# Unit/widget tests
flutter test

# With coverage
flutter test --coverage
```

## Project-Specific Patterns

### Firestore Model Serialization
All models implement `fromMap()` factory and `toMap()` method:
```dart
factory ClassName.fromMap(String id, Map<String, dynamic> data) {
  return ClassName(
    id: id,
    // map fields from data
  );
}

Map<String, dynamic> toMap() {
  return {
    // serialize fields to map
  };
}
```

### Service Class Pattern
Services in `lib/services/` are singletons wrapping Firebase/external APIs:
- Direct Firestore/Auth/Messaging access
- Error logging with debugPrint
- Async operations with proper error handling
- Example: `NotificationService` initializes FCM, stores tokens in Firestore, handles message routing

### Provider Data Flow
1. Service fetches data from Firebase
2. Provider processes and exposes via state
3. Provider calls `notifyListeners()` on state change
4. Screens consume via `Provider.of<>()` or `context.read<>()`

### Order Status Flow
Orders progress through statuses: `pending` → `confirmed` → `preparing` → `ready` → `delivered`
Payment status tracked separately: `pending` | `paid` | `failed`

## External Dependencies & Integrations

### Key Libraries
- **State**: `provider: ^6.0.7` (Provider pattern, not Riverpod)
- **Firebase**: Core, Auth, Firestore, Storage, Messaging
- **Payments**: `razorpay_flutter: ^1.3.5` (payment processing)
- **Notifications**: Firebase Messaging + `flutter_local_notifications: ^17.2.0`
- **Persistence**: `shared_preferences: ^2.3.2`, `sqflite: ^2.2.0`
- **Social Auth**: Google Sign-In, Facebook Auth, Twitter Login
- **UI**: Lottie animations, Carousel slider, FL Charts, Material Design

### Email Service
- Uses `mailer: ^6.2.1` for sending emails
- Integration point: `MailerService` in services

### WhatsApp Integration
- `WhatsappService` likely for order notifications via WhatsApp
- Check [whatsapp_service.dart] for implementation

## File Organization Conventions

### Screen Structure
- Role-based subfolder organization: `auth/`, `admin/`, `chef/`, `vendor/`, etc.
- Each feature has dedicated folder: `orders/`, `menu/`, `wallet/`, `feedback/`, `payment/`
- Nested services/providers in relevant feature folders

### Model Naming
- Singular for data classes: `Order`, `User`, `MenuItem`, `Feedback`
- Plural for collections: `orders`, `users`, `menu_items`
- Model relationships defined via ID references (no nested objects)

## Common Tasks & Examples

### Fetching Data from Firestore
Use FirestoreService methods - handles queries and collection operations

### Adding New Order Status
1. Update Order model status field valid values
2. Update order_provider.dart to handle new status
3. Update order tracking UI to display new status
4. Update order_service.dart methods that modify status

### Adding Auth Role
1. Add to `UserRole` enum in auth_provider.dart
2. Create role-specific screen in `screens/<role>/`
3. Update navigation logic in `auth_wrapper.dart`
4. Set default role on signup if needed

### Notification Flow
1. Firebase Messaging receives FCM token
2. NotificationService saves token to Firestore `users` collection
3. Backend sends to FCM using stored tokens
4. App receives and shows via FlutterLocalNotificationsPlugin

## Important Notes

- **No Null Safety Warnings**: Code uses `!` assertions heavily - ensure non-null before using
- **Commented Code**: `main.dart` and `app.dart` contain extensive commented old code - safe to ignore but don't remove without verification
- **Email in pubspec.yaml**: App has mailer dependency - credentials likely in `.env` via `flutter_dotenv`
- **Multi-Platform Support**: Firebase configured for Web, Android, iOS, macOS, Windows
- **Test Dependencies**: Uses Mockito and fake_cloud_firestore for testing

## Quick Reference: Key Files
- [lib/main.dart](lib/main.dart) - App entry point
- [lib/app.dart](lib/app.dart) - Material app config and routes
- [lib/auth_wrapper.dart](lib/auth_wrapper.dart) - Auth state & navigation logic
- [lib/providers/auth_provider.dart](lib/providers/auth_provider.dart) - Central auth state
- [lib/services/firestore_service.dart](lib/services/firestore_service.dart) - Database operations
- [lib/services/notification_service.dart](lib/services/notification_service.dart) - FCM + notifications
