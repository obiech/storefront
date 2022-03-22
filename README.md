# storefront-app

Dropezy Storefront mobile app developed in Flutter.

# Getting started

## Firebase Setup

Setup is done using manual installation as described on [FlutterFire docs](https://firebase.flutter.dev/docs/manual-installation).

### Android

1. Download `google-services.json` from Dropezy Android App on Firebase Console.
2. Put the file in `android/app/google-services.json`.

### iOS

1. Download `GoogleService-Info.plist` from Dropezy iOS App on Firebase Console.
2. Put the file in `ios/GoogleService-Info.plist`.
3. Create a Xcode Configuration file for Firebase in `Flutter/Firebase.xcconfig`. For quick setup, copy `Flutter/Firebase.xcconfig.example` with this command:

```bash
cp ./ios/Flutter/Firebase.xcconfig.example ./ios/Flutter/Firebase.xcconfig
```

---

**Q: Why not use Dart initialization (FlutterFire CLI)?**

A: There is an issue with Dart initialization when running on physical iOS device. See this [issue](https://github.com/FirebaseExtended/flutterfire/issues/7983).

## Setting up Environment Variables

Environment variables are loaded using [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) package.

Create a file named `env/.env` in your local repository. This file should not be commited and
is added into `.gitignore`.

To quickly setup your local environment, copy the `env.example` file with this command:

```bash
cp ./env/.env.example ./env/.env
```

Then make changes as necessary.

In the Flutter App, all references to environment variables are placed in classes inside `lib/constants/config` directory
and divided according to their domain for easier maintenance.

## Pre-push checks

We have set up Git hooks to prevent extra whitespace and other possible mistakes before pushing the code to your branch. Run the below command in the project root directory to copy the pre-push hooks to your local `.git` directory.

```bash
  cp ./hooks/pre-push.example ./.git/hooks/pre-push
```
