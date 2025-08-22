<!-- Frame App Information & Links -->
<br />

![GitHub repo size](https://img.shields.io/github/repo-size/KaylaPosthumusOW/frame_app?color=8e44ad)
![GitHub watchers](https://img.shields.io/github/watchers/KaylaPosthumusOW/frame_app?color=8e44ad)
![GitHub language count](https://img.shields.io/github/languages/count/KaylaPosthumusOW/frame_app?color=8e44ad)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/KaylaPosthumusOW/frame_app?color=8e44ad)

<!-- HEADER SECTION -->
<h5 align="center">Kayla Posthumus - 231096</h5>
<h6 align="center">Interactive Development 300 • 2025</h6>
</br>
<p align="center">
  <div align="center">
   <img src="assets/svg/frame_logo.svg" alt="Frame Logo" height="70">
  </div>
  <h3 align="center">Frame</h3>
  <p align="center">
   Embrace your creativity. Frame is a social creativity platform built with Flutter, Firebase, and Bloc.<br>
   <a href="#getting-started"><strong>Explore the docs »</strong></a>
   <br />
   <br />
   <a href="https://drive.google.com/drive/folders/1XwCTKuCkLniLhOSJbFpcelUqbM4tKs9w?usp=sharing">View Demo</a>
   ·
   <a href="https://github.com/KaylaPosthumusOW/frame_app/issues">Report Bug</a>
   ·
   <a href="https://github.com/KaylaPosthumusOW/frame_app/issues">Request Feature</a>
  </p>

## Table of Contents
- [About Frame](#about-fram)
- [Built With](#built-with)
- [Getting Started](#getting-started)
- [Frame Features & Functionality](#fram-features--functionality)
- [Screenshots](#screenshots)
- [Author](#author)
- [Contact](#contact)

## About Frame
<img src="assets/mock_ups/homepage.png" alt="Homepage - Today's Prompt & Frame" height="400" align="center">

### Project Description
Frame is a social creativity platform where users can share daily creative frames, interact with the community, and track their creative streaks. Built with Flutter and Dart, Frame leverages Firebase for authentication, Firestore for data storage, and Bloc for robust state management.

## Built With
- **Flutter**: UI toolkit for building natively compiled applications
- **Dart**: Programming language for Flutter
- **Firebase**: Authentication, Firestore, Storage
- **Bloc**: State management
- **GoRouter**: Navigation
- **CachedNetworkImage**: Image caching
- **Google Fonts**: Typography
- **FontAwesome**: Icon library
- **Frame Packages**: Custom packages for Frame functionality (see `pubspec.yaml`)

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Firebase Project](https://console.firebase.google.com/)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)

### Installation
1. **Clone Repository**
  ```sh
  git clone https://github.com/KaylaPosthumusOW/frame_app.git
  ```
2. **Navigate to Project Directory**
  ```sh
  cd frame_app
  ```
3. **Install Dependencies**
  ```sh
  flutter pub get
  ```
4. **Firebase Setup**
  - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders.
  - Configure Firestore, Auth, and Storage in the Firebase Console.
5. **Run the App**
  ```sh
  flutter run
  ```



## Frame Features & Functionality

<details open>
  <summary><strong>🔑 Sign In / Login</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-1.png" alt="Sign In Mockup" height="220" style="margin-right:24px;">
    <img src="assets/page_mock_ups/iPhone 14 Pro.png" alt="Sign In Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>Modern login screen with real-time validation and error handling</li>
        <li>Persistent sessions powered by Firebase Auth</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Onboarding</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/mock_ups/onboarding_pages.png" alt="Onboarding Mockup" height="200" style="margin-right:24px;">
    <div>
      <ul>
        <li>Guided onboarding screens introduce Frame's features and community</li>
        <li>Onboarding is only shown the first time you log in, ensuring a smooth start for new users</li>
        <li>After onboarding, users are taken directly to the homepage on future logins</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Homepage</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-3.png" alt="Homepage Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>Track today's creative prompt and your daily frame</li>
        <li>View, upload, and share your frame</li>
        <li>Streak tracking and progress visualization</li>
        <li>Quick access to community gallery and comments</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Your Gallery</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-8.png" alt="Homepage Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>View your uploaded frames</li>
        <li>Track your creative progress through the weeks</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Community & Engagement</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-2.png" alt="Community Gallery Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>Browse, and comment on community frames</li>
        <li>Real-time comment system with profile images and timestamps</li>
        <li>Reporting & moderation: report posts for admin review and archiving</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Profile Page - With Admin Functions</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-4.png" alt="Community Gallery Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>View and edit your profile</li>
        <li>Upload your profile image</li>
        <li>Admin Has access to the functions for managing prompts and reported posts</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Notifications Page</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/Notifications.png" alt="Community Gallery Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>View the posts that have been reported by users</li>
        <li>Be able to see the reason why it was reported</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Admin - Prompt Management</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-5.png" alt="Admin Page Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>Create, edit, and delete daily prompts</li>
        <li>Archive prompts to keep the community engaged with fresh content</li>
      </ul>
    </div>
  </div>
</details>

<details open>
  <summary><strong>Admin - Reported Posts Management</strong></summary>
  <div style="display: flex; align-items: center;">
    <img src="assets/page_mock_ups/iPhone 14 Pro-6.png" alt="Admin Page Mockup" height="220" style="margin-right:24px;">
    <div>
      <ul>
        <li>View and manage reported posts</li>
        <li>Archive posts that violate community guidelines</li>
        <li>Ensure a safe and respectful community environment</li>
      </ul>
    </div>
  </div>
</details>

## Highlights
- Building my first mobile app using Flutter and Firebase
- Learning to integrate Firebase Authentication, Firestore, and Storage
- Designing a modern, responsive UI for both Android and iOS
- Implementing robust state management with Bloc and Cubits

## Challenges
- Adapting to Flutter's navigation and routing, especially managing page stacks
- Understanding and correctly using Bloc states and Cubits for reactive UI
- Debugging state issues and ensuring smooth user experience

## Future Implementation
- Add image editing and creative tools for frames
- Implement push notifications for new prompts and community interactions
- Implement advanced notification settings and scheduling
- Introduce leaderboards and creative competitions

## Final Outcome
<p align="center">
  <img src="assets/mock_ups/mockup_1.png" alt="Admin Page" height="400">
  <img src="assets/mock_ups/features.png" alt="Community Gallery" height="400">
</p>


## Author
- **Kayla Posthumus** - Developer & Designer

## Contact
- **KaylaPosthumusOW** - [https://github.com/KaylaPosthumusOW]
- **Project Link** - [https://github.com/KaylaPosthumusOW/frame_app]

## Acknowledgements
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Spaza! Tech] - My mentor and support throughout the project
