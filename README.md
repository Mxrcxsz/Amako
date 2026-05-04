# 📖 Amako — Manga Reading App

Amako is an iOS manga reading application developed as a school project. Built with Swift in Xcode using the MVC architectural pattern, it allows users to discover, read, and keep track of their favourite manga — all in one place.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 **User Authentication** | Register and log in securely with Firebase Authentication |
| 🔍 **Search Manga** | Search for any manga by title using the MangaDex API |
| 📋 **Manga Details** | View detailed information including synopsis, genres, and a full chapter list |
| 📖 **Read Manga** | Read chapters page by page directly within the app |
| ❤️ **Favourites** | Save manga to your favourites list for quick access |
| 🕓 **Reading History** | Automatically track and revisit manga you've previously read |

---

## 📸 App Demo
https://github.com/user-attachments/assets/1afc8a58-96a9-416d-9151-23084a444023


---

## 🛠️ Tech Stack

- **Platform:** iOS (Xcode)
- **Language:** Swift
- **Architecture:** MVC (Model-View-Controller)
- **API:** [MangaDex API](https://api.mangadex.org) — for fetching manga data, chapter listings, and page images
- **Database / Backend:** [Firebase](https://firebase.google.com) — for user authentication, favourites, and reading history

---

## 🏗️ Architecture

Amako follows the **MVC (Model-View-Controller)** design pattern:

- **Model** — Data structures representing manga, chapters, users, and reading history. Handles all Firebase read/write operations and MangaDex API calls.
- **View** — Storyboard-based UI screens including login, search results, manga detail, chapter reader, favourites, and history.
- **Controller** — View controllers that mediate between the model and view layers, handling user interactions and updating the UI accordingly.

---

## 🔌 API — MangaDex

Amako uses the [MangaDex API](https://api.mangadex.org) to:
- Search manga by title
- Fetch manga metadata (title, description, cover art, tags)
- Retrieve a list of available chapters
- Load individual chapter pages for reading

---

## 🔥 Firebase Integration
Firebase powers the backend functionality of Amako:
- **Firebase Authentication** — Handles user registration and login
- **Cloud Firestore** — Stores each user's favourites list and reading history, tied to their account

---

## 🚀 Getting Started

### Prerequisites
- Xcode 14 or later
- An active [Firebase](https://firebase.google.com) project with Authentication and Firestore enabled
- Internet connection (for MangaDex API and Firebase)

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/amako.git
   cd amako
   ```

2. Open `Amako.xcodeproj` in Xcode.

3. Add your `GoogleService-Info.plist` from your Firebase project into the Xcode project root.

4. Build and run the app on a simulator or physical device.

---

## 👤 Author

Developed as a school project.

---

## 📄 License

This project is for educational purposes only. Manga content is provided through the [MangaDex API](https://api.mangadex.org) and remains the property of their respective authors and publishers.
