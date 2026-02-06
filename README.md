```markdown
# Daily Habit Tracker App

A modern and scalable **Daily Habit Tracker** application built using **Flutter** and **Firebase**, designed to help users build consistency by tracking habits on a **day-by-day basis** with a clean and intuitive user experience.

This project was developed during my internship as an **App Developer Intern** at **APM – Alpha Pixel Media**.

---

## Overview

The Daily Habit Tracker allows users to create habits and mark them as completed for individual dates.  
Unlike traditional habit apps that store a single status, this app maintains **date-wise habit completion**, enabling accurate tracking, streak calculation, and future analytics.

---

## Features

- Date-wise habit tracking
- Interactive horizontal date picker
- Create habits with name, description, interval, and icon
- Real-time data synchronization using Firebase Firestore
- Minimal and premium UI inspired by iOS design principles
- Scalable architecture for future enhancements

---

## Technology Stack

- **Flutter (Dart)**
- **Firebase Firestore**
- **Provider** – state management
- **Google Fonts**
- **Font Awesome Icons**

---

## Project Structure

```

lib/
├── main.dart
├── providers/
│   └── date_provider.dart
├── screens/
│   └── home_screen.dart
└── widgets/
├── add_habit_popup.dart
├── date_picker.dart
└── show_habit.dart

````

---

## Habit Status Logic

Each habit stores completion status per date using a map structure.

Example Firestore document:
```json
{
  "name": "Workout",
  "status": {
    "2026-02-05": "done",
    "2026-02-06": "none"
  }
}
````

This approach enables:

* Accurate daily tracking
* Easy streak calculation
* Weekly and monthly progress insights

---

## Getting Started

### Prerequisites

* Flutter SDK installed
* Firebase project created
* Cloud Firestore enabled

### Installation

```bash
git clone https://github.com/your-username/daily_habit_app.git
cd daily_habit_app
flutter pub get
flutter run
```

---

## Future Improvements

* Habit streak tracking
* Weekly and monthly analytics
* Dark mode support
* Offline data caching
* Advanced animations and transitions

---

## Internship Details

* **Organization:** APM – Alpha Pixel Media
* **Role:** App Developer Intern
* **Work Focus:**

  * Flutter UI development
  * Firebase integration
  * State management
  * Feature implementation

---

## License

This project is intended for educational and internship purposes.

---

## Author

**Munna Shaheem**
App Developer Intern – APM Alpha Pixel Media
Flutter Developer

---

⭐ If you find this project useful, consider starring the repository.

```

---

If you want next, I can:
- Optimize it for **resume & LinkedIn**
- Add **screenshots & GIFs**
- Write a **project description for internships/jobs**
- Create a **portfolio-ready case study**

Just say the word 🚀
```
