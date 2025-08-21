# Frame App

Frame App is a Flutter-based social platform for sharing daily photo frames, tracking streaks, and engaging with a community. It features robust onboarding, profile management, image upload flows, prompt management, and admin tools for moderation.

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Setup & Installation](#setup--installation)
- [Environment Variables](#environment-variables)
- [Running the App](#running-the-app)
- [Testing](#testing)
- [Key Workflows](#key-workflows)
- [Admin Tools](#admin-tools)
- [Contributing](#contributing)
- [License](#license)

## Features
- **Onboarding:** Only shown to new users.
- **Profile Management:** Edit profile, upload profile photo, view streaks.
- **Daily Frame Upload:** Capture and upload a daily frame, with captions and community sharing.
- **Prompt System:** Daily prompts for frame inspiration, managed by admins.
- **Streak Tracker:** Track active days and streaks.
- **Community Feed:** View and interact with community frames.
- **Admin Tools:** Manage prompts, review and moderate reported posts.
- **Robust Navigation:** Stackless, error-free navigation using GoRouter.
- **Error Handling:** Snackbars and UI feedback for all major actions.

## Tech Stack
- **Flutter** (Dart)
- **Firebase** (Firestore, Storage, Auth)
- **Bloc** (State Management)
- **GoRouter** (Navigation)
- **MasonryGridView** (Community feed)
- **File Picker** (Image selection)

## Project Structure
```
lib/
  constants/         # App-wide constants and themes
  core/              # Core utilities and helpers
  cubits/            # Bloc cubits for state management
  models/            # Data models (User, Post, Prompt)
  stores/            # Firestore repositories
  ui/
    screens/         # Main screens (Home, Profile, Admin, etc.)
    widgets/         # Reusable widgets (Buttons, Modals, etc.)
assets/
  pngs/              # PNG images
  svg/               # SVG images
android/ios/         # Native platform code
```

## Setup & Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/KaylaPosthumusOW/frame_app.git
   cd frame_app
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders.
   - Set up Firestore, Storage, and Auth in the Firebase console.
4. **Update environment variables:**
   - See `.env.example` for required keys (if applicable).

## Environment Variables
- Firebase API keys and project config
- Any other secrets required for third-party integrations

## Running the App
- **Android/iOS:**
  ```sh
  flutter run
  ```
- **Web:**
  ```sh
  flutter run -d chrome
  ```

## Testing
- Run unit and widget tests:
  ```sh
  flutter test
  ```

## Key Workflows
### Daily Frame Upload
- Tap the capture button on the home screen.
- Take/select a photo, add a caption, and upload.
- Frame is saved to Firebase Storage and Firestore.

### Profile Photo Upload
- Edit profile and tap the photo to upload a new image.
- Image is uploaded and profile updated in Firestore.

### Prompt Management (Admin)
- Admins can create, edit, and set prompts as current.
- Only one prompt can be current at a time.
- Used prompts are displayed in the admin panel.

### Reported Posts (Admin)
- Admins can review, approve, or archive reported posts.
- Snackbars provide feedback for moderation actions.

## Admin Tools
- Accessible only to users with `UserRole.admin`.
- Prompt management and reported posts moderation.

## Contributing
1. Fork the repo and create your branch.
2. Make changes and commit with clear messages.
3. Open a pull request.

## License
This project is licensed under the MIT License.

---
For questions or support, contact the repository owner or open an issue on GitHub.
