\# SnapShare 📸



A social media mobile application inspired by Instagram, built with Flutter and Firebase.



\## Screenshots

<p float="left">

   <img src="screenshots/login.jpg" width="200"/>

   <img src="screenshots/signup.jpg" width="200"/>

   <img src="screenshots/feed.jpg" width="200"/>

   <img src="screenshots/create_post.jpg" width="200"/>

   <img src="screenshots/profile.jpg" width="200"/>

</p>



\## Features



\- 🔐 \*\*User Authentication\*\* — Sign up, log in, and log out securely using Firebase Auth

\- 👤 \*\*User Profile\*\* — View your username, post count, and a grid of your posts

\- 📷 \*\*Create Posts\*\* — Pick an image from your gallery, add a caption and share it

\- 🏠 \*\*Home Feed\*\* — View posts from all users in real time, newest first

\- ⚡ \*\*Live Updates\*\* — Feed and profile update instantly without refreshing



\## Tech Stack



| Technology | Purpose |

|---|---|

| Flutter \& Dart | Mobile app framework |

| Firebase Authentication | User login and signup |

| Cloud Firestore | Database for users and posts |

| image\_picker | Pick images from device gallery |



\## Project Structure



lib/



├── main.dart



├── firebase\_options.dart



├── models/



│   ├── user\_model.dart



│   └── post\_model.dart



├── services/



│   ├── auth\_service.dart



│   └── post\_service.dart



└── screens/



├── splash\_screen.dart



├── auth/



│   ├── login\_screen.dart



│   └── signup\_screen.dart



├── home/



│   ├── home\_screen.dart



│   └── post\_card.dart



├── post/



│   └── create\_post\_screen.dart



└── profile/



└── profile\_screen.dart



\## Getting Started



\### Prerequisites

\- Flutter SDK

\- Android Studio (for Android SDK)

\- Firebase account



\### Setup



1\. \*\*Clone the repository\*\*

```bash

&#x20;  git clone https://github.com/KartikSaini267/snapshare.git

&#x20;  cd snapshare

```



2\. \*\*Create a Firebase project\*\*

&#x20;  - Go to https://console.firebase.google.com

&#x20;  - Enable Authentication (Email/Password)

&#x20;  - Enable Cloud Firestore

&#x20;  - Run `flutterfire configure` to generate `firebase\_options.dart`



3\. \*\*Install dependencies\*\*

```bash

&#x20;  flutter pub get

```



4\. \*\*Run the app\*\*

```bash

&#x20;  flutter run

```



\### Important Note

`firebase\_options.dart` and `google-services.json` are excluded from this

repository for security. You must configure your own Firebase project to run this app.



\## Firestore Structure



users/



{uid}/



username, email, postCount, createdAt

posts/



{postId}/



userId, username, imageBase64, caption, createdAt



\## Author



\*\*Kartik Saini\*\*  

GitHub: \[@KartikSaini267](https://github.com/KartikSaini267)

