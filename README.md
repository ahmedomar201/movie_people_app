
# 🎬 Movie People App

A Flutter application that displays popular people (actors, directors, etc.) using [The Movie Database API (TMDB)](https://www.themoviedb.org/).

![App Screenshot_1](assets/images/screenshot1.png)  
![App Screenshot_2](assets/images/screenshot2.png)
![App Screenshot_3](assets/images/screenshot2.png)
![App Screenshot_4](assets/images/screenshot2.png)

---

## 🚀 Features

- Display a list of **popular people** with infinite scrolling.
- View **person details** including department and popularity.
- Grid view of **person images** from TMDB.
- Tap on any image to **view it fullscreen**.
- **Download images** to the device gallery (mobile only).
- Error handling and loading indicators.
- Clean architecture using Cubit for state management.

---

## 🧰 Libraries Used

- `flutter_bloc` – State management
- `dio` – API requests
- `get_it` – Dependency injection
- `dartz` – Result types (Either)
- `permission_handler` – Handle storage permissions
- `flutter_native_splash` – Native splash screen

---

## 🗂️ Project Structure

```
lib/
├── core/           # Helpers, constants, services
├── dataLayer/      # Models, API, repository
├── presentationLayer/
│   ├── screens/    # UI screens
│   └── widgets/    # Reusable widgets
```

---

## 🛠️ Getting Started

### 1. Prerequisites

Ensure you have Flutter installed. [Installation Guide](https://flutter.dev/docs/get-started/install)

### 2. Installation

```bash
git clone https://github.com/ahmedomar201/movie_people_app.git
cd movie_people_app
flutter pub get
```


### 4. Run the App

```bash
flutter run
```

---

## 📱 Platform Notes

- ✅ Android/iOS: image download requires storage permission.
- Compatible with Android 10+ and iOS 13+.

---

## 🧠 Design Decisions

- **Cubit** chosen for lightweight state management.
- **Repository pattern** used to separate concerns.
- **Clean Architecture** ensures scalability and testability.
- All async/network errors are gracefully handled.

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
