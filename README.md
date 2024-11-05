# Blossom Women Health App

## Overview
Blossom Women Health Care is a Flutter-based application designed to provide personalized health solutions for women. Built with Flutter SDK 3.19.2 and Dart 3.3.0, this app integrates Firebase services to offer features like symptom tracking, AI-generated health advice, and specialist recommendations.

## Getting Started

### Prerequisites

- [Flutter SDK 3.19.2](https://flutter.dev/docs/get-started/install)
- [Dart SDK 3.3.0](https://dart.dev/get-dart)
- [Firebase Account](https://firebase.google.com/)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com//himashagunasena/Hackathon-Women-Health-App.git
   
#### 2. Install dependencies

```bash
flutter pub get
```

#### 3. Set up Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Add an Android and/or iOS app to your Firebase project.
3. Follow the instructions to download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS).
4. Place these files in the appropriate directory in your Flutter project:
   - `android/app` for `google-services.json`
   - `ios/Runner` for `GoogleService-Info.plist`
5. Enable Firestore, Authentication, and any other services you need in the Firebase Console.

#### 4. Run the app

```bash
flutter run
```

## Project Structure

- `main.dart`: The entry point of the application.
- `Presentation/`: Contains the UI screens of the app.
- `widgets/`: Contains reusable UI components.
- `models/`: Contains data models.
- `services/`: Contains services like Firebase operations.
- `controller/`: Contains firebase functions.
- `utils/`: Contains utility classes and constants.

## Features

- **Self Disease Tracking**: Users can input symptoms via text or images, and the app leverages AI to analyze these inputs, offering tailored health advice.
- **AI-Generated Weekly Advice**: The app reviews the user’s weekly symptom entries and generates customized health advice to support proactive health management.
- **Symptom Analysis and Doctor Guidelines**: After analyzing symptoms, the app suggests relevant health guidelines and recommends specialists who can address specific concerns.
- **Specialist Recommendations**: AI identifies and recommends nearby doctors based on the user’s location and required specialization.
- **Daily Health Tracker**: Users can log daily symptoms, generating a weekly health summary along with proactive advice based on recent symptoms.
- **Blog for Health Education**: Users can read and write curated articles on health, wellness, and lifestyle.
- **Blog Comment Section**: Users can disscuss problem in comment section.
- **Historical Health Data**: Stores past health data for users to review, enabling them to monitor changes over time.

## Usage

### Running the App

To run the app on a connected device or emulator:

```bash
flutter run
```

### Building the App

To build the app for release:

```bash
flutter build apk
```

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries, please contact himasha.gunasena123@gmail.com.
```

This template should cover all the main aspects you mentioned. Feel free to customize the details to match your specific project needs.
