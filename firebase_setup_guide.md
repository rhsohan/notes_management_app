# Complete Firebase Setup Guide for Flutter

This guide covers everything required to set up Cloud Firestore for a Flutter application from scratch.

## Step 1: Install Required CLIs
To connect your Flutter app to Firebase automatically, you need both the Firebase CLI and the FlutterFire CLI.

1. **Install Firebase CLI** (requires Node.js to be installed on your computer):
   Open a terminal and run:
   ```bash
   npm install -g firebase-tools
   ```
2. **Log into Firebase**:
   ```bash
   firebase login
   ```
   *This will open your browser. Log in with the Google account you want to use for Firebase.*
3. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```

## Step 2: Configure the Flutter Project
Now that you have the tools, you can link your specific Flutter project to Firebase.

1. **Create the Project in the Browser (Recommended)**:
   Go to the [Firebase Console](https://console.firebase.google.com/), click **Add project**, and create a new project. Doing this first is highly recommended to avoid command-line typing issues.
2. **Run the configuration command**:
   Once the project is created in the browser, go back to your terminal and run the command again:
   ```bash
   dart pub global run flutterfire_cli:flutterfire configure
   ```
3. **Follow the interactive prompts**:
   * It will show a list of your existing projects. Use the arrow keys to select the project you just created and press Enter.
   * It will ask which platforms to support. Keep the defaults (Android, iOS, Web, etc.) checked by pressing Enter.
4. **Wait for completion**:
   The CLI will automatically register your apps in Firebase and generate a new file in your project at `lib/firebase_options.dart`.

## Step 3: Create the Firestore Database in the Console
Even though your project is linked, the actual database hasn't been created yet.

1. Go to the [Firebase Console](https://console.firebase.google.com/) in your web browser.
2. Click on the project you just created.
3. In the left-hand menu, click on **Build**, then click on **Firestore Database**.
4. Click the **Create database** button.
5. **Important**: When it asks for security rules, choose **Start in test mode**. 
   *(Test mode allows your app to read and write data immediately without needing user authentication, which is perfect for development).*
6. When it asks for the Location and Database ID, leave the defaults (e.g., `(default)` and `nam5`) and click **Create**.

## Step 4: Add Dependencies
Your Flutter app needs the Firebase packages to talk to the database.

1. Run these commands in your project folder terminal:
   ```bash
   flutter pub add firebase_core
   flutter pub add cloud_firestore
   ```

## Step 5: Update `main.dart`
Finally, initialize Firebase inside your Flutter code before the app runs.

Update your `lib/main.dart` to include the initialization logic:
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // This is the file flutterfire generated
import 'screens/notes_list_screen.dart';

void main() async {
  // Required when initializing Firebase before runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase with the options for the current platform
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
  
  runApp(const NotesApp());
}
```

## You are done!
You can now run your app (`flutter run -d chrome`). Whenever you add, edit, or delete notes in your app, you will see those changes reflect immediately in the Firebase Console under your Firestore Database!
