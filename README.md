# SnapShare 📸

A social media mobile application inspired by Instagram, built with Flutter and Firebase.

## Screenshots

<p float="left">
  <img src="screenshots/login.jpg" width="200"/>
  <img src="screenshots/signup.jpg" width="200"/>
  <img src="screenshots/feed.jpg" width="200"/>
  <img src="screenshots/create_post.jpg" width="200"/>
  <img src="screenshots/profile.jpg" width="200"/>
</p>

## Features

- 🔐 **User Authentication** — Sign up, log in, and log out securely using Firebase Auth
- 👤 **User Profile** — View your username, post count, and a grid of your posts
- 📷 **Create Posts** — Pick an image from your gallery, add a caption and share it
- 🏠 **Home Feed** — View posts from all users in real time, newest first
- ⚡ **Live Updates** — Feed and profile update instantly without refreshing

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter & Dart | Mobile app framework |
| Firebase Authentication | User login and signup |
| Cloud Firestore | Database for users and posts |
| image_picker | Pick images from device gallery |

## Project Structure

lib/

├── main.dart

├── firebase_options.dart

├── models/

│   ├── user_model.dart

│   └── post_model.dart

├── services/

│   ├── auth_service.dart

│   └── post_service.dart

└── screens/

├── splash_screen.dart

├── auth/

│   ├── login_screen.dart

│   └── signup_screen.dart

├── home/

│   ├── home_screen.dart

│   └── post_card.dart

├── post/

│   └── create_post_screen.dart

└── profile/

└── profile_screen.dart

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio (for Android SDK)
- Firebase account

### Setup

1. **Clone the repository**
```bash
   git clone https://github.com/KartikSaini267/snapshare.git
   cd snapshare
```

2. **Create a Firebase project**
   - Go to https://console.firebase.google.com
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Run `flutterfire configure` to generate `firebase_options.dart`

3. **Install dependencies**
```bash
   flutter pub get
```

4. **Run the app**
```bash
   flutter run
```

### Important Note
`firebase_options.dart` and `google-services.json` are excluded from this
repository for security. You must configure your own Firebase project to run this app.

## Firestore Structure

users/

{uid}/

username, email, postCount, createdAt
posts/

{postId}/

userId, username, imageBase64, caption, createdAt

## Author

**Kartik Saini**  
GitHub: [@KartikSaini267](https://github.com/KartikSaini267)
