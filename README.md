# 📱 Flutter Project for Energy Data Monitoring 

## 📌 Overview
This project is a Flutter-based application designed to fetch and visualize daily data analytics for various energy generation and consumption metrics. It provides a seamless user experience, displaying insights through interactive charts and filtering options. It is built using Flutter and Dart, ensuring a seamless cross-platform experience for Android iOS and Web.

## 📂 Project Structure
```
lib/
│── app/
│   ├── app.dart
│   ├── app_bloc_observer.dart
│
│── charts_overview/
│   ├── bloc/
│   ├── cubit/
│   ├── view/
│   ├── widget/
│
│── data/
│   ├── data_sources/
│   ├── models/
│   ├── repositories/
│
│── home/
│   ├── cubit/
│   ├── view/
│   ├── widget/
│
│── util/
│   ├── chart_data_util.dart
│
│── main.dart
```

## 🔧 Installation & Setup

Ensure you have the following installed on your system:
- Flutter SDK: [Download here](https://flutter.dev/docs/get-started/install)
- Dart SDK (included with Flutter)
- Android Studio or VS Code as IDE

### Steps to Run the App
1. Open the project folder in your IDE and prepare the backend API docker solution in advance.
   *(used Flutter SDK version for this project: 3.27.3)*

2. Navigate into the project directory via terminal:
   ```bash
   cd your-repo
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🏗️ Implemented Architecture
This project follows the **Bloc (Business Logic Component)** architecture for state management. Bloc is a widely used state management approach in Flutter, known for its efficient management of data streams and UI state across multiple layers.

### **Why Bloc?**
Bloc has been selected due to its:
- Powerful state management capabilities.
- Strong data stream management over different layers.
- Clear separation of concerns, avoiding tight coupling between the layers.

### **Bloc Architecture & Project Structure**
- **Bloc/Cubit Layer:** Acts as an intermediary between the View and Data layers, handling business logic.
- **View Layer:** Strictly responsible for UI rendering and presentation, without performing any business logic operations.
- **Data Layer:** Includes repositories and data sources, fetching data from local storage or network services and sending it to the Bloc layer.
- **Feature Modules:** Each feature (e.g., `home`, `charts_overview`) is structured as a separate module to maintain clean architecture principles.
- **Data State Management using Bloc:** The Bloc state management approach is used to manage the different states of data: **Initial, Loading, Success, and Failure**. Based on the result of the back-end API response or the availability of local data, the state is updated accordingly. If data is loaded successfully, it is processed and displayed in the UI. If an error occurs, a user-friendly message is shown along with a retry option to allow the user to fetch the data again.

## 🎯 Testing
- For unit and widget tests, necessary testing and mocking libraries such as **bloc_test** for Bloc and **mocktail** for mocking dependencies have been included.
- Unit tests and widget tests have been implemented to the extent possible within the project timeline.
- The project architecture and **Dependency Injection** have been structured to ensure testability for each class and unit.
- Tests have been implemented for:
   - **Data Sources and Repository classes**
   - **Bloc layer**
   - **Widget tests for the View layer**

## 🎨 Implemented UI Features
### Overview
Based on the given back-end API, which has limited capabilities for data fetching and filtering, the data is available only per single day. The data for each type of metric (Solar, House, and Battery) is displayed based on the given date. The application presents this data in a line chart, differentiated into three distinct tabs for each metric type.

### Date Filtering
- A date filtering bar is implemented at the top for selecting specific dates.
- A tab selection bar with **Day, Week, Month, and Year** options has been added for aesthetic purposes, although it does not provide functionality due to the back-end API's filtering limitations.
- Below the tabs, users can navigate through daily data manually, fetching new data on demand.
- As per requirements, data for other charts is **prefetched (cached)** to ensure that switching between chart tabs does not trigger unnecessary loading delays.

### Chart Visualization
- The **syncfusion_flutter_charts** library is used for rendering charts, providing features like **zooming and panning** to enhance user experience.
- Due to a high volume of data points per day for each metric, **data aggregation** is implemented to prevent clutter and improve readability while maintaining the accuracy of the displayed information.

### Additional Features
- **Dark Mode Support:** A toggle switch on the top right of the app bar allows users to switch between light and dark themes.
- **Cache Management:** An option in the menu (top left) allows users to **clear cached data**. Upon clearing, users are prompted to **refetch** data from the backend for a fresh dataset.
- **Pull to Refresh:** To provide an easier way for users to refresh data, a built-in **RefreshIndicator** from Flutter SDK has been implemented. Users can **drag down** from the top of the view to refresh and fetch the latest data from the backend.

## 🔍 Further Potential Improvements / Trade-offs Due to Time Constraints
### Data Polling
- Implementing data polling as an additional feature was considered but could not be incorporated due to time limitations.

### Design
- A more polished UI adhering to Google’s Material Design standards and best UI/UX practices would have improved the user experience. However, due to time constraints, the design was kept minimal.

### Resource Bundle
- Utilizing a structured resource bundle for defining texts across different parts of the application would have enhanced maintainability and localization support. Unfortunately, this was not feasible within the project timeline.

### More Unit Test and Widget Test Coverage
- Expanding test coverage to include all units and widgets across various scenarios and edge cases would have helped in preventing unforeseen errors and bugs. However, testing was implemented to the extent allowed by the available time.

### Testing on iOS and Other Platforms
- The app has only been tested on Android and web platforms. Due to device limitations, testing on iOS and other necessary platforms was not possible, which remains an important aspect for future development.

### Cache Feature
- A suggested improvement for caching would be adding an option to **disable caching**, meaning that data would not be loaded at once for all charts. Instead, switching between tabs would trigger a data fetch and show a loading state to the user.

