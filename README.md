# 🌤️ SkyCast Weather App

## 1. Project Overview & Objective
**SkyCast** is a modern, responsive, and feature-rich Flutter application that provides real-time weather information, forecasts, and interactive weather insights.

* **Objective:** The core objective of this project is to provide users with a clean, fast, and ad-free interface to check live weather, temperature, humidity, and wind speed for any city globally. The project is built using modern architectural patterns and a secure CI/CD pipeline via GitHub Actions.

---

## 2. Tech Stack
To ensure high scalability and performance, the following technologies and tools are utilized:

| Component | Technology / Tool | Description |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter (Dart) | Used for cross-platform UI development (Android & iOS). |
| **Target SDK (Android)** | API 34+ | Aligned with the latest Google Play Store guidelines. |
| **API Integration** | OpenWeatherMap / WeatherAPI | Fetches real-time accurate weather data and forecasts. |
| **State Management** | Provider / BLoC | Efficiently manages the app state and data flow. |
| **CI/CD Pipeline** | GitHub Actions | Automated build testing and automatic APK generation. |

---

## 3. Scope of the Project
SkyCast aims to assist users in daily life planning through predictive weather modeling.
* **In-Scope:** Real-time data fetching, location-based weather updates, multi-day forecasts, interactive UI weather condition indicators (sun, rain, clouds animations), and online API network management.
* **Out-of-Scope (Current Version):** Offline data caching, historical climate data, and push notification weather alerts.

---

## 4. Functional Requirements
Functional requirements define the core features and direct user-interactions within the application:

* **FR-1: City Search:** Users must be able to type any city name into the search bar to fetch its current weather conditions.
* **FR-2: Current Weather Display:** The app must display the exact temperature (Celsius/Fahrenheit), weather condition text (e.g., Sunny, Rainy, Cloudy), humidity percentage, and wind speed.
* **FR-3: Multi-day Forecast:** Display weather forecasts and expected temperature highs/lows for the next 3 to 5 days.
* **FR-4: Dynamic UI Backgrounds:** The interface theme, backgrounds, and structural icons must dynamically change based on the weather condition of the selected city.
* **FR-5: Pull-to-Refresh:** Users should be able to manually refresh the weather data by performing a pull-down gesture on the screen.

---

## 5. Non-Functional Requirements
Non-functional requirements specify the criteria used to judge the operation, quality, and security of the system:

* **NFR-1: Performance & Speed:** Weather data retrieval and UI rendering must take less than 2 seconds under stable network conditions.
* **NFR-2: Security (API Key Protection):** Private Weather API keys must not be hardcoded into the source files. Instead, keys are injected securely via GitHub Secrets and `--dart-define` during the compilation process.
* **NFR-3: Usability (UI/UX):** Font sizing, contrast ratios, and iconography must follow Material Design standards for optimal readability across various demographics.
* **NFR-4: Reliability & Error Handling:** If the network is unavailable or the API service fails, the app must gracefully handle the exception and display an intuitive "No Internet Connection" or "Server Error" message rather than crashing.

---

## 6. Future Enhancements
Planned upgrades to scale the application in future release cycles:

* **GPS Location Access:** Integrate automated geolocation services to display local weather immediately upon opening the app.
* **Severe Weather Alerts:** Background service integration to push real-time notifications for extreme weather alerts (e.g., storms, heatwaves).
* **Home-Screen Widgets:** Configurable desktop/home-screen widgets for Android and iOS to glance at weather details without launching the full application.
* **Live Radar Map:** Embedded interactive maps overlaying cloud tracking, precipitation radar, and wind patterns using OpenStreetMap layers.

---


