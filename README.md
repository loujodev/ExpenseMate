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

3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Run the app:**
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
