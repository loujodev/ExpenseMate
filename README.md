# ExpenseMate - Expense Tracking App

ExpenseMate is a mobile application built with Flutter to help you track your income and expenses, manage categories, and gain insights into your spending habits.

## Features

* **Expense & Income Tracking:** Easily add and categorize your financial transactions.
* **Category Management:** Create and manage custom spending categories.
* **Dashboard Overview:** Visualize your financial situation with charts and summaries.
* **User Authentication:** Secure your data with Firebase authentication.
* **Theme Customization:** Switch between light and dark themes.

<img width="990" alt="Screenshot 2025-05-22 at 00 47 46" src="https://github.com/user-attachments/assets/c90dc104-2cfb-4984-9c95-29258f08f606" />


## Tech Stack

* **Frontend:** Flutter (iOS, Android, Web)
* **Backend & Authentication:** Firebase (Firestore, Firebase Auth)
* **State Management:** Provider
* **Local Storage:** SQLite (via sqflite)

## Getting Started

This project is a standard Flutter application.

1.  **Prerequisites:**
    * Ensure you have Flutter installed on your system. For guidance, see the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
    * A configured Firebase project. You'll need to add your own `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to the respective platform folders. See `lib/firebase_options.dart` for the required Firebase configuration structure.

2.  **Clone the repository:**
    ```bash
    git clone [your-repository-url]
    cd expense_mate
    ```
3.  **Set up Firebase:**
    * This project **requires Firebase** for authentication functionalities. You will need to set up your own Firebase project to protect sensitive data in my own `lib/firebase_options.dart`
    * Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.

        * Register your iOS app with your Firebase project. Make sure the iOS Bundle ID matches `com.example.expenseMate` (or update it in Xcode if you change it).
        * Download the `GoogleService-Info.plist` file from your Firebase project settings.
        * Open the `ios` folder of this project in Xcode, and drag and drop the `GoogleService-Info.plist` file into the `Runner` subfolder (ensure it's added to the Runner target).
    * **Configure Firebase in Flutter:**
        * You need to ensure your Flutter app is configured with your Firebase project's specific options. The easiest way to do this is by using the FlutterFire CLI:
            1.  Install or update the Firebase CLI: `npm install -g firebase-tools` (or `sudo npm install -g firebase-tools`)
            2.  Install or update the FlutterFire CLI: `dart pub global activate flutterfire_cli`
            3.  Log in to Firebase: `firebase login`
            4.  In the root directory of this project, run: `flutterfire configure`
            5.  This command will guide you to select your Firebase project and will automatically generate the `lib/firebase_options.dart` file with your project's specific credentials. It will also update native Firebase configurations if needed.
    * **Enable Firebase Services:**
        * In the Firebase Console, enable the following services for your project:
            * **Authentication:** Enable Email/Password sign-in method. You may also want to enable other methods as needed.

4.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

5.  **Run the app:**
    ```bash
    flutter run
    ```

## Project Structure

The application follows a feature-first approach with a clear separation of concerns (MVVM-like architecture):

* `lib/src/features/`: Contains feature-specific modules (e.g., auth, categorypage, dashboardpage).
    * `data/`: Repositories for data handling.
    * `presentation/`: UI (screens, widgets) and presentation logic.
* `lib/src/shared/`: Contains shared components, utilities, and services.
    * `controllers/`: ChangeNotifier classes (ViewModels) for state management.
    * `domain/`: Data models.
    * `services/`: Services like database interaction, location, etc.
    * `theme/`: Theme definitions.
