# Audio Only Meeting App - Students

A Flutter application for students to join and participate in audio meetings. This app allows students to join live meetings, listen to host broadcasts, and access recorded sessions.

## Features

- Student authentication system
- Join live meetings
- Real-time audio streaming
- View and play meeting recordings
- Profile management can update his password
- Private audio chat with host
- Background audio playback
- Network bandwidth optimization

## Getting Started

### Prerequisites

- Flutter SDK ^3.6.1
- Dart SDK ^3.6.1
- Android Studio / VS Code
- Android device/emulator (API 21 or higher)
- iOS device/simulator (iOS 11.0 or higher)

### Installation

1. Clone the repository:

2. Navigate to project directory:
   ```bash
   cd audio-meeting-app-student
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Configuration

1. Create a `.env` file in the project root and add your configuration:
   ```
   API_BASE_URL=192.168.1.74:5000/api
   SOCKET_URL=ws://192.168.1.74:5000/
   ```

2. Configure Firebase:
   - Add `google-services.json` for Android in `android/app/`
   - Add `GoogleService-Info.plist` for iOS in `ios/Runner/`

## Usage

### Authentication
- Launch the app and sign in using your student credentials
- First-time users need to complete profile setup

### Joining Meetings
1. Navigate to 'Live Meetings' tab
2. Select the meeting you want to join
3. Wait for host approval
4. Use audio controls to manage your listening experience

### Accessing Recordings
1. Go to 'Recordings' section
2. Browse available recordings
3. Tap to play/pause
4. Use seek bar for navigation

## Architecture

The app follows Clean Architecture principles with MVVM pattern:
- `lib/presentation/` - UI components
- `lib/domain/` - Business logic
- `lib/data/` - Data sources and repositories
- `lib/core/` - Shared utilities
