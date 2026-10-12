# MediTech

MediTech is a Flutter application designed to help patients find medicine availability at nearby independent pharmacies. Its goal is to reduce unnecessary trips to drugstores by making medicine information easier to access.

The project includes a Flutter frontend, a Node.js and Express backend, and Supabase for cloud authentication and database services. The current implementation includes account registration, sign-in, profile retrieval, and dashboard navigation. Pharmacy discovery, stock management, and medicine reservation are part of the broader project vision and should be documented as implemented only when those features are available.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation and Setup](#installation-and-setup)
- [Environment Configuration](#environment-configuration)
- [How to Run the Application](#how-to-run-the-application)
- [Backend API](#backend-api)
- [Database and Authentication](#database-and-authentication)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [How to Contribute on GitHub](#how-to-contribute-on-github)
- [Security Notes](#security-notes)
- [Future Development](#future-development)

## Features

### Implemented

- Flutter-based user interface.
- User registration with full name, email, and password.
- User sign-in using Supabase authentication through the backend API.
- Profile retrieval using an authenticated request.
- Navigation to the dashboard after successful sign-in.
- Form validation and password visibility controls.
- Supabase-backed user accounts and profile data.

### Project Goals

- Help patients locate nearby independent pharmacies.
- Allow users to check medicine availability before visiting a pharmacy.
- Support medicine reservations for pickup.
- Provide a pharmacy portal for managing medicine inventory.
- Display useful pharmacy information, including location and availability.

The pharmacy-related features depend on the implementation and integration of the necessary services and data sources.

## Technologies Used

| Technology | Purpose |
|---|---|
| Dart | Main programming language for the Flutter application |
| Flutter | Frontend and cross-platform user interface |
| Material 3 | UI components and theming |
| Inter | Application typeface |
| Node.js | Backend JavaScript runtime |
| Express.js | Backend API and request handling |
| Supabase Auth | User registration and authentication |
| Supabase Database | Cloud-hosted PostgreSQL database |
| `http` | HTTP requests from Flutter to the backend |
| `@supabase/supabase-js` | Supabase integration in the Node.js backend |
| `dotenv` | Loading backend environment variables |
| SQLite | Originally considered for the backend; the current configured implementation uses Supabase instead |

Refer to `pubspec.yaml` for Flutter dependencies and `meditech-backend/package.json` for backend dependencies.

## Prerequisites

Install the following tools before running the project:

| Tool | Purpose | Verification |
|---|---|---|
| Git | Clone and manage the repository | `git --version` |
| Flutter SDK | Build and run the application | `flutter --version` |
| Dart SDK | Included with Flutter | `dart --version` |
| Node.js | Run the backend server | `node --version` |
| npm | Install backend packages | `npm --version` |
| Supabase account | Configure cloud authentication and database | Open the Supabase dashboard |
| Chrome or an Android device | Run the Flutter application | `flutter devices` |
| VS Code or another editor | Edit the project | Optional |

For Android development, Android Studio and the Android SDK may also be needed.

Run `flutter doctor` to check your Flutter development environment.

## Project Structure

```text
Meditech/
├── assets/
│   ├── fonts/
│   └── images/
│       └── logo.png
├── lib/
│   ├── main.dart
│   ├── sign_in.dart
│   ├── sign_up.dart
│   └── dashboard.dart
├── meditech-backend/
│   ├── server.js
│   ├── package.json
│   ├── package-lock.json
│   └── .gitignore
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
├── test/
├── .gitignore
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

Some folders contain generated platform or build files and may not appear in every checkout.

## Installation and Setup

### 1. Clone the repository

```bash
git clone https://github.com/johnemmanuelpieza-ops/Meditech.git
cd Meditech
```

### 2. Install Flutter dependencies

From the root project directory, run:

```bash
flutter pub get
```

### 3. Configure the backend

Open a terminal in the repository root and enter the backend folder:

```bash
cd meditech-backend
npm install
```

Create a `.env` file inside `meditech-backend/`.

Add your own Supabase project configuration:

```dotenv
SUPABASE_URL=your_supabase_project_url
SUPABASE_KEY=your_supabase_publishable_or_anon_key
PORT=3000
```

Use the exact environment variable names expected by `server.js`. If your code uses a different key name, match the name in that file.

Replace the example values with your own project credentials. Never commit the real `.env` file.

Return to the repository root when you finish configuring the backend:

```bash
cd ..
```

### 4. Configure Supabase

Create or select a Supabase project.

The backend requires a configured Supabase project with authentication enabled and the profile table and policies expected by the application.

The current profile setup uses a `profiles` table linked to Supabase Auth users. Registration should create the corresponding profile through the configured database trigger or equivalent application logic.

Make sure the table, trigger, and Row Level Security policies are configured before testing account registration and profile retrieval.

### 5. Configure the API URL

The Flutter application needs the URL of the backend server.

For local development, the current configuration uses:

```dart
const String loginApiBaseUrl = 'http://localhost:3000';
```

This address is suitable when running Flutter Web on the same computer as the backend.

For Android emulators, physical devices, and deployed applications, `localhost` may refer to the device itself rather than your computer. Use the appropriate reachable backend address for your testing environment.

For production, replace the local address with your deployed HTTPS backend URL.

## Environment Configuration

### Backend environment variables

| Variable | Description |
|---|---|
| `SUPABASE_URL` | URL of your Supabase project |
| `SUPABASE_KEY` | Supabase key used by the backend |
| `PORT` | Port used by the Express server; the local default is `3000` |

Use the key type supported by your backend implementation. A publishable key or legacy anon key may be used for client-scoped requests, while privileged service-role or secret keys must remain server-side.

Do not include actual credentials in this README.

### Example `.gitignore` entries

Make sure the repository ignores environment files and generated dependencies:

```gitignore
.env
.env.*
!.env.example
node_modules/
```

Keep these rules in the appropriate `.gitignore` files. If a sensitive file has already been committed, adding it to `.gitignore` alone will not remove it from Git history.

## How to Run the Application

You need two terminals for local development.

### Terminal 1: Start the backend

From the repository root:

```bash
cd meditech-backend
npm install
node server.js
```

The backend should start on the configured port.

Check its health endpoint in your browser:

```text
http://localhost:3000/health
```

The expected response is:

```json
{
  "status": "healthy"
}
```

Keep the backend terminal running while testing the application.

### Terminal 2: Start Flutter

Open another terminal in the repository root:

```bash
flutter pub get
flutter run -d chrome
```

To run on an Android device, first check the available device IDs:

```bash
flutter devices
```

Then use the device ID shown by Flutter:

```bash
flutter run -d YOUR_DEVICE_ID
```

The backend must be reachable from the device running the application.

### Production builds

To build the Flutter application for different targets:

```bash
flutter build apk --release
flutter build appbundle --release
flutter build web --release
```

The web build is generated in `build/web`. These commands build the frontend; they do not deploy the backend or host the application automatically.

## Backend API

The current backend exposes the following endpoints.

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/` | Basic server response |
| `GET` | `/health` | Check backend health |
| `POST` | `/register` | Register a user |
| `POST` | `/login` | Authenticate a user |
| `GET` | `/profile` | Retrieve the authenticated user's profile |

### Registration

Send a `POST` request to `/register` with the registration details:

```json
{
  "fullName": "Sample User",
  "email": "user@example.com",
  "password": "your-password"
}
```

The backend forwards registration to Supabase Auth. Depending on the Supabase email-confirmation settings, a user may need to verify their email before signing in.

### Sign-in

Send a `POST` request to `/login`:

```json
{
  "email": "user@example.com",
  "password": "your-password"
}
```

A successful response includes an access token and user information.

The Flutter sign-in screen uses the response to retrieve the user's name and navigate to the dashboard.

### Profile retrieval

Send a `GET` request to `/profile` with the access token in the authorization header:

```http
Authorization: Bearer YOUR_ACCESS_TOKEN
```

The backend validates the token and retrieves the corresponding profile.

Never publish real access tokens in documentation, screenshots, source code, or GitHub commits.

## Database and Authentication

Supabase provides cloud-hosted authentication and PostgreSQL database services.

The current authentication flow is:

1. A user submits the registration form.
2. The backend sends the registration request to Supabase Auth.
3. The user signs in with their registered credentials.
4. The backend returns an access token and user information.
5. The Flutter application requests the user's profile when needed.
6. The application opens the dashboard after successful authentication.

Profile access should be restricted to the authenticated user through proper authorization checks and Row Level Security policies.

The database and authentication services are cloud-hosted, but the Node.js backend remains local until it is deployed to a hosting provider.

## Testing

Run the available Flutter tests and static analysis from the repository root:

```bash
flutter test
flutter analyze
```

To verify backend connectivity, start the server and visit:

```text
http://localhost:3000/health
```

Also test the following manually:

- Register an account with valid details.
- Verify email confirmation if it is enabled.
- Sign in with valid credentials.
- Confirm that incorrect credentials produce an error.
- Confirm that the correct user's name appears on the dashboard.
- Check profile retrieval using a valid access token.
- Test the application when the backend is unavailable.
- Verify that protected profile requests reject invalid or missing tokens.

Only report tests as passed after they have actually been executed.

## Troubleshooting

| Problem | What to try |
|---|---|
| Flutter dependencies are missing | Run `flutter pub get` |
| Node.js packages are missing | Run `npm install` inside `meditech-backend` |
| Backend fails to start | Check `server.js`, `.env`, dependencies, and whether the port is already in use |
| `/health` cannot be reached | Confirm the backend is running on the expected port |
| Login fails unexpectedly | Check credentials, Supabase Auth settings, backend logs, and API URL |
| Registration succeeds but sign-in fails | Check whether email confirmation is required |
| Profile information is missing | Verify the `profiles` table, registration trigger, access token, and RLS policies |
| Flutter Web reports a CORS error | Configure backend CORS to allow the actual frontend origin |
| Android cannot connect to `localhost` | Use the correct emulator or reachable server address |
| Build errors occur after changing dependencies | Run `flutter clean`, then `flutter pub get` |

## How to Contribute on GitHub

Contributions and improvements are welcome.

1. Fork the repository on GitHub.
2. Clone your fork:

   ```bash
   git clone https://github.com/YOUR_USERNAME/Meditech.git
   cd Meditech
   ```

3. Add the original repository as an upstream remote:

   ```bash
   git remote add upstream https://github.com/johnemmanuelpieza-ops/Meditech.git
   ```

4. Create a feature branch:

   ```bash
   git checkout -b feature/short-description
   ```

5. Make your changes and run the relevant tests.

6. Stage and commit your changes:

   ```bash
   git add .
   git commit -m "Add short description of change"
   ```

7. Push your branch:

   ```bash
   git push origin feature/short-description
   ```

8. Open a pull request against the original repository's `main` branch.

### Contribution guidelines

- Keep each change focused on a specific improvement.
- Use clear commit messages.
- Test changes before opening a pull request.
- Follow the existing Flutter UI style and Inter typography.
- Do not commit `.env`, access tokens, passwords, or other secrets.
- Do not commit generated build folders or `node_modules`.
- Include screenshots when a change affects the user interface.

Report bugs or suggest improvements through the [GitHub Issues page](https://github.com/johnemmanuelpieza-ops/Meditech/issues).

## Security Notes

- Keep backend credentials in environment variables.
- Never put Supabase service-role or secret keys in Flutter code.
- Use HTTPS for deployed API communication.
- Validate input on the backend rather than relying only on Flutter form validation.
- Protect user profiles with authentication and appropriate database policies.
- Restrict CORS to the frontend origins you intend to allow.
- Rotate any credentials that have been accidentally exposed.

## Future Development

Planned improvements may include:

- Cloud deployment of the Node.js backend.
- Nearby pharmacy discovery using a suitable location or places API.
- Medicine availability and inventory management.
- Pharmacy-side stock updates.
- Medicine reservation and pickup workflows.
- Additional integration and end-to-end tests.

These features should be marked as completed only after they are implemented and verified.
