# Hipster Assignment Task

A modern Flutter application featuring video calling capabilities and user management with offline
support.

## Features

- **Video Calling**: One-to-one video calls using Agora RTC Engine
- **User Management**: Browse and manage users with pagination
- **Offline Support**: Smart caching for seamless offline experience
- **Modern UI**: Clean, responsive design with smooth animations
- **Authentication**: Secure login system with session management

## Screenshots

The app includes:

- Splash screen with smooth animations
- Login screen with form validation
- Home screen with navigation options
- Users list with modern card design
- Video call interface with controls

## Prerequisites

Before running this project, ensure you have:

- **Flutter SDK** (3.9.0 or higher)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development on macOS)
- **Git** for version control

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd hipster_assignment_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

##️ Running the App

### Debug Mode

**Android:**

```bash
flutter run
```

**iOS:**

```bash
flutter run
```

**Specific Device:**

```bash
flutter devices
flutter run -d <device-id>
```

### Release Mode

**Android APK:**

```bash
flutter build apk --release
```

**Android App Bundle (for Play Store):**

```bash
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

## Configuration

### Agora RTC Engine

The app uses Agora RTC Engine for video calling. The configuration is already set up with:

- **App ID**: `a9f7f312cd2c4d8abf56a0e6bfe89888`
- **Token**: Empty (testing mode)
- **Channel**: `Meet-1`

### API Configuration

The app uses the ReqRes API for user data:

- **Base URL**: `https://reqres.in/api/`
- **API Key**: `reqres-free-v1`

### Login Credentials

For testing the app, use these credentials:

- **Email**: `eve.holt@reqres.in`
- **Password**: `cityslicka`

> **Note**: These are test credentials from the ReqRes API. The app will authenticate successfully with these credentials.

## Platform-Specific Setup

### Android

1. **Minimum SDK**: 21 (Android 5.0)
2. **Target SDK**: 34 (Android 14)
3. **Permissions**: Already configured in `AndroidManifest.xml`

**Required Permissions:**

- Camera
- Microphone
- Internet
- Network State
- Wake Lock
- Foreground Service

### iOS

1. **Minimum iOS**: 11.0
2. **Permissions**: Already configured in `Info.plist`

**Required Permissions:**

- Camera Usage
- Microphone Usage

## Build Instructions

### Android Build

1. **Debug Build**
   ```bash
   flutter build apk --debug
   ```

2. **Release Build**
   ```bash
   flutter build apk --release
   ```

3. **App Bundle (Recommended for Play Store)**
   ```bash
   flutter build appbundle --release
   ```

### iOS Build

1. **Open in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure Signing**
    - Select your development team
    - Choose appropriate provisioning profile

3. **Build from Xcode**
    - Product → Archive
    - Distribute App

## Deployment

### Google Play Store

1. **Build App Bundle**
   ```bash
   flutter build appbundle --release
   ```

2. **Upload to Play Console**
    - Navigate to Play Console
    - Create new release
    - Upload the generated `.aab` file

### Apple App Store

1. **Build for iOS**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**
    - Open `ios/Runner.xcworkspace`
    - Product → Archive
    - Distribute App → App Store Connect

## App Signing

### Android Signing

The app is configured to use debug keys by default. For production:

1. **Generate Keystore**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Create `key.properties`**
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Update `android/app/build.gradle`**
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

### iOS Signing

1. **Apple Developer Account**: Required for distribution
2. **Provisioning Profiles**: Create for your app
3. **Certificates**: Download and install in Keychain

## App Versioning

Current version: **1.0.0+1**

- **Version Name**: 1.0.0 (user-facing version)
- **Version Code**: 1 (internal build number)

To update version:

```bash
# Update version in pubspec.yaml
version: 1.0.1+2

# Build with new version
flutter build apk --release
```

## Project Structure

```
lib/
├── core/
│   ├── custom_widgets/     # Reusable UI components
│   ├── services/           # Core services (cache, connectivity)
│   ├── theme/              # App theming and colors
│   └── utils/              # Utility functions
├── feature/
│   ├── auth/               # Authentication feature
│   ├── Home/               # Home screen feature
│   ├── users/              # Users management feature
│   ├── video_call/         # Video calling feature
│   └── splashscreen/       # Splash screen
├── routes/                 # App routing configuration
└── main.dart              # App entry point
```

## Freezed Model Classes & State Management

This project uses **Freezed** for creating immutable model classes and state management. Freezed
provides code generation for data classes, union types, and pattern matching.

### Prerequisites

Make sure you have these dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.8.0
  freezed: ^3.2.3
  json_serializable: ^6.11.1
```

### Creating Freezed Model Classes

#### 1. Basic Data Model

Create a new model file (e.g., `lib/feature/users/models/user_model.dart`):

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    @Default('') String email,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @Default('') String avatar,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

#### 2. State Management Class

Create a state file (e.g., `lib/feature/users/models/ui_stats/users_state.dart`):

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../user_model.dart';

part 'users_state.freezed.dart';

@freezed
abstract class UsersState with _$UsersState {
  const factory UsersState({
    @Default(false) bool isLoading,
    @Default([]) List<UserModel> usersList,
    @Default(0) int totalDataCount,
    int? nextPageIndex,
    @Default(false) bool isOffline,
    @Default(false) bool isFromCache,
    String? lastError,
  }) = _UsersState;
}

extension UsersStateExtension on UsersState {
  UsersState get toggleLoading => copyWith(isLoading: !isLoading);
}
```

#### 3. Union Types (for different states)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.loading() = Loading<T>;

  const factory ApiResult.success(T data) = Success<T>;

  const factory ApiResult.error(String message) = Error<T>;
}
```

### 🔧 Code Generation Scripts

#### 1. Generate All Code

```bash
# Generate all Freezed and JSON serialization code
flutter packages pub run build_runner build

# Clean and regenerate (if you have conflicts)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter packages pub run build_runner watch
```

#### 2. Generate Specific Files

```bash
# Generate only Freezed files
flutter packages pub run build_runner build --build-filter="lib/**/*.freezed.dart"

# Generate only JSON serialization files
flutter packages pub run build_runner build --build-filter="lib/**/*.g.dart"
```

### Freezed Best Practices

#### 1. Model Class Structure

```dart
@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String name,
    @Default(0.0) double price,
    @Default([]) List<String> tags,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default(ProductStatus.active) ProductStatus status,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

enum ProductStatus { active, inactive, discontinued }
```

#### 2. State Class with Extensions

```dart
@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default(false) bool isLoading,
    @Default([]) List<ProductModel> products,
    @Default('') String searchQuery,
    String? error,
  }) = _ProductState;
}

extension ProductStateExtension on ProductState {
  bool get hasError => error != null;

  bool get isEmpty => products.isEmpty && !isLoading;

  List<ProductModel> get filteredProducts =>
      products
          .where((product) => product.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
}
```

#### 3. Union Types for API States

```dart
@freezed
abstract class DataState<T> with _$DataState<T> {
  const factory DataState.initial() = Initial<T>;

  const factory DataState.loading() = Loading<T>;

  const factory DataState.success(T data) = Success<T>;

  const factory DataState.error(String message) = Error<T>;
}

// Usage in UI
Widget buildDataState(DataState<List<User>> state) {
  return state.when(
    initial: () => const Text('No data'),
    loading: () => const CircularProgressIndicator(),
    success: (data) =>
        ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => UserTile(user: data[index]),
        ),
    error: (message) => Text('Error: $message'),
  );
}
```

### Automated Code Generation

#### 1. Create a Build Script

Create `scripts/generate_code.sh`:

```bash
#!/bin/bash

echo "Generating Freezed and JSON serialization code..."

# Clean previous generated files
echo "Cleaning previous generated files..."
flutter packages pub run build_runner clean

# Generate new code
echo "⚡ Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "Code generation completed!"
```

#### 2. Make it Executable

```bash
chmod +x scripts/generate_code.sh
```

#### 3. Run Code Generation

```bash
# Run the script
./scripts/generate_code.sh

# Or run directly
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 🔍 Common Freezed Patterns

#### 1. Copy With Pattern

```dart
// Update state immutably
final newState = currentState.copyWith(
  isLoading: true,
  error: null,
);

// Update list
final updatedState = currentState.copyWith(
  usersList: [...currentState.usersList, newUser],
);
```

#### 2. Pattern Matching

```dart
// Using when() for union types
final result = apiResult.when(
  loading: () => 'Loading...',
  success: (data) => 'Data: $data',
  error: (message) => 'Error: $message',
);

// Using map() for more complex operations
final widget = apiResult.map(
  loading: (_) => CircularProgressIndicator(),
  success: (state) => DataWidget(data: state.data),
  error: (state) => ErrorWidget(message: state.message),
);
```

#### 3. JSON Serialization

```dart
// Convert to JSON
final json = userModel.toJson();

// Convert from JSON
final user = UserModel.fromJson(json);

// Handle nullable fields
@JsonKey(name: 'optional_field')
String? optionalField;
```

### Troubleshooting Code Generation

#### Common Issues

1. **Build Runner Conflicts**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Missing Generated Files**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build
   ```

3. **Import Errors**
    - Make sure to include both `.freezed.dart` and `.g.dart` parts
    - Check that the part files match your class name

#### Debug Commands

```bash
# Check for build issues
flutter analyze

# Clean everything and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter packages pub run build_runner watch
```

### Freezed Documentation

- [Freezed Package](https://pub.dev/packages/freezed)
- [JSON Annotation](https://pub.dev/packages/json_annotation)
- [Build Runner](https://pub.dev/packages/build_runner)

### Quick Reference

```bash
# Essential commands
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch
flutter packages pub run build_runner clean

# Check generated files
ls lib/**/*.freezed.dart
ls lib/**/*.g.dart
```

## 🔧 Troubleshooting

### Common Issues

1. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Permission Issues**
    - Ensure all permissions are properly declared
    - Check device settings for app permissions

3. **Agora Issues**
    - Verify App ID is correct
    - Check network connectivity
    - Ensure proper permissions are granted

### Debug Mode

Enable debug logging:

```bash
flutter run --debug
```

## Dependencies

### Main Dependencies

- `flutter_bloc`: State management
- `go_router`: Navigation
- `agora_rtc_engine`: Video calling
- `shared_preferences`: Local storage
- `permission_handler`: Permission management
- `freezed`: Code generation
- `json_annotation`: JSON serialization

### Dev Dependencies

- `build_runner`: Code generation
- `freezed`: Immutable classes
- `json_serializable`: JSON serialization
- `flutter_lints`: Linting rules

