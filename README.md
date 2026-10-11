# MediTech

MediTech is a mobile app and pharmacy web portal that lets patients check medicine availability at nearby independent drugstores, reserve stock for pickup, and avoid wasted trips.

Finding a specific medicine often means visiting several drugstores before one has it in stock. MediTech is built to remove that guesswork: patients see what is available nearby before they leave home, and drugstores get a simple way to show and manage their stock.

## Table of Contents

- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
- [How to Run the Code](#how-to-run-the-code)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Testing](#testing)
- [How to Contribute on GitHub](#how-to-contribute-on-github)
- [Usage Examples](#usage-examples)

## Technologies Used

| Technology | Version | Purpose |
| ---------- | ------- | ------- |
| [Dart](https://dart.dev) | SDK `^3.13.5` | Programming language |
| [Flutter](https://flutter.dev) | Stable channel | UI framework for building the app |
| Material 3 | Included with Flutter | Base widgets and theming |
| [Inter](https://fonts.google.com/specimen/Inter) | Bundled font files | App typeface, registered in `pubspec.yaml` |
| `cupertino_icons` | `^1.0.8` | Icon set (Flutter default) |
| `flutter_test` | Included with Flutter | Widget testing |
| `flutter_lints` | `^6.0.0` | Lint rules used by `flutter analyze` |

No databases, external APIs, or third-party packages beyond the Flutter defaults are used at the moment.

## Prerequisites

| Tool | Why you need it | How to check |
| ---- | --------------- | ------------ |
| [Git](https://git-scm.com/downloads) | Clone the repository | `git --version` |
| [Flutter SDK](https://docs.flutter.dev/get-started/install) | Build and run the app. Use a stable release that bundles Dart 3.13.5 or newer | `flutter --version` |
| Dart SDK | Comes with Flutter | `dart --version` |
| A device to run on | One of: Chrome, an Android emulator or phone, or a desktop target for your OS | `flutter devices` |
| Android Studio (optional) | Needed for Android emulators and the Android SDK | `flutter doctor` |

Run `flutter doctor` after installing. It checks your whole setup and tells you what is missing.

No API keys, environment variables, database services, or external accounts are required.

## Installation and Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/johnemmanuelpieza-ops/Meditech.git
   ```

2. **Go into the project folder**

   ```bash
   cd Meditech
   ```

3. **Install the dependencies**

   ```bash
   flutter pub get
   ```

4. **Confirm your setup is healthy**

   ```bash
   flutter doctor
   ```

There is no database or configuration file to set up.

## How to Run the Code

List the devices Flutter can see, then run the app on one of them:

```bash
flutter devices
flutter run
```

`flutter run` builds the app and launches it. If more than one device is available, Flutter asks which one to use. You can also choose directly:

| Target | Command |
| ------ | ------- |
| Chrome (web) | `flutter run -d chrome` |
| Android emulator or phone | `flutter run -d <device-id>` |
| Windows, macOS, or Linux desktop | `flutter run -d windows` / `macos` / `linux` |

While the app is running in the terminal:

| Key | Action |
| --- | ------ |
| `r` | Hot reload |
| `R` | Hot restart (use this after changing the theme, fonts, or `pubspec.yaml`) |
| `q` | Quit |

When running on Chrome, the terminal prints the local address. To use a fixed port, add `--web-port 8080` and open `http://localhost:8080`.

### Production builds

```bash
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle (for Google Play)
flutter build web --release        # Web build, output in build/web
```

### Troubleshooting

| Problem | What to try |
| ------- | ----------- |
| `flutter: command not found` | Add the Flutter `bin` folder to your `PATH`, then reopen the terminal |
| SDK version error mentioning `^3.13.5` | Run `flutter upgrade` to get a newer stable release |
| `Target of URI doesn't exist` or missing package | Run `flutter pub get` |
| Error about a missing font or asset | Check that the files in `assets/fonts/` and `assets/images/logo.png` exist and match `pubspec.yaml`, then run `flutter clean` followed by `flutter pub get` |
| Theme, font, or page animation changes do not appear | Use a full restart (`R`), not hot reload |
| Android licenses not accepted | Run `flutter doctor --android-licenses` |
| No devices found | Start an emulator, plug in a phone with USB debugging on, or use `-d chrome` |
| Odd build errors after switching branches | Run `flutter clean`, then `flutter pub get` |

## Project Structure

```
Meditech/
├── .vscode/              # Editor settings
├── android/              # Android platform project
├── ios/                  # iOS platform project
├── linux/                # Linux desktop platform project
├── macos/                # macOS desktop platform project
├── web/                  # Web platform project
├── windows/              # Windows desktop platform project
├── assets/
│   ├── fonts/            # Inter font files
│   └── images/
│       └── logo.png      # MediTech logo
├── lib/
│   ├── main.dart         # App entry point, theme, page transition, landing screen
│   ├── sign up.dart      # Sign up screen
│   └── sign in.dart      # Sign in screen
├── test/
│   └── widget_test.dart  # Widget test
├── .gitignore            # Files Git should not track
├── .metadata             # Flutter project metadata (do not edit by hand)
├── analysis_options.yaml # Lint and analyzer settings
├── pubspec.yaml          # Dependencies, assets, and font registration
└── pubspec.lock          # Locked dependency versions
```

## Configuration

The app currently needs no environment variables, API keys, or `.env` file, so there is no `.env.example` to copy.

The settings you may want to change live in `pubspec.yaml`:

| Setting | Location | Notes |
| ------- | -------- | ----- |
| App name and version | `name`, `version` | `version: 1.0.0+1` is the version name and build number |
| Dart SDK constraint | `environment.sdk` | Currently `^3.13.5` |
| Fonts | `flutter.fonts` | Inter weights 400 to 900 are registered under the family name `Inter` |
| Assets | `flutter.assets` | The logo is listed here. Any new image must be added to this list |

The Android application ID is `com.example.meditech`. Change it before publishing the app to a store.

## Testing

The project uses Flutter's built-in widget testing (`flutter_test`). The test file is `test/widget_test.dart`.

```bash
flutter test      # run the tests
flutter analyze   # check the code for errors and lint warnings
```

Run both before opening a pull request. Only widget tests exist so far. There are no integration tests yet.

## How to Contribute on GitHub

Contributions are welcome, including from beginners. Follow these steps.

1. **Fork the repository.** Click **Fork** at the top right of the [repository page](https://github.com/johnemmanuelpieza-ops/Meditech). This creates your own copy.

2. **Clone your fork** to your computer, replacing `<your-username>` with your GitHub username:

   ```bash
   git clone https://github.com/<your-username>/Meditech.git
   cd Meditech
   ```

3. **Connect the original repository** so you can pull in future updates:

   ```bash
   git remote add upstream https://github.com/johnemmanuelpieza-ops/Meditech.git
   ```

4. **Create a new branch** for your change. Never work directly on `main`:

   ```bash
   git checkout -b feature/short-description
   ```

5. **Make your changes, then test them:**

   ```bash
   flutter pub get
   flutter analyze
   flutter test
   flutter run
   ```

6. **Stage and commit** your changes:

   ```bash
   git add .
   git commit -m "Add short description of the change"
   ```

7. **Push the branch** to your fork:

   ```bash
   git push origin feature/short-description
   ```

8. **Open a Pull Request.** Go to your fork on GitHub and click **Compare & pull request**. Make sure the base repository is `johnemmanuelpieza-ops/Meditech` and the base branch is `main`. Describe what you changed and why, add screenshots for visual changes, then submit. Wait for review and make any requested changes by committing and pushing to the same branch. The pull request updates automatically.

To keep your fork up to date before starting new work:

```bash
git checkout main
git pull upstream main
git push origin main
```

### Guidelines

- **Commit messages:** write a short, clear summary in the present tense, such as `Add password length validation`. Avoid vague messages like `update` or `fix stuff`.
- **Keep changes focused:** one pull request should do one thing. Do not mix unrelated fixes and features.
- **Test before submitting:** run `flutter analyze` and `flutter test`, and run the app to check that your change works.
- **Keep the repository clean:** do not commit the `build/` folder, `.dart_tool/`, IDE files, or other generated files. The `.gitignore` covers most of these.
- **Never commit secrets:** do not add API keys, passwords, tokens, or private credentials.
- **Follow the existing style:** the app uses the Inter font, and the design colors and spacing come from the Figma designs.
- **Report bugs and suggest features** by opening an [issue](https://github.com/johnemmanuelpieza-ops/Meditech/issues). For bugs, include what you did, what you expected, what happened, and your device or browser.

## Usage Examples

The app currently supports this flow.

### Create an account

1. Launch the app. The landing page shows the MediTech logo and a **Get started** button.
2. Tap **Get started** to open the Sign up screen.
3. Enter your full name, a valid email address, and a password of at least 8 characters.
4. Tick **I agree to the terms**. The **Create account** button turns solid green.
5. Tap **Create account**. A floating "Account created" message appears.

### Sign in

1. From the landing page, tap **Sign in** at the bottom (or use **Sign in** on the Sign up screen).
2. Enter your email address and password. Tap **Show** to reveal the password.
3. Tick **Remember me**. The **Sign in** button turns solid green.
4. Tap **Sign in**. A floating "Signed in" message appears.

### Form validation

If a field is empty or invalid when you tap the green button, a red message appears under that field and nothing continues:

| Field | Rule |
| ----- | ---- |
| Full name (sign up) | Must not be empty |
| Email address | Must not be empty and must be a valid email format |
| Password (sign up) | Must not be empty and must be at least 8 characters |
| Password (sign in) | Must not be empty |

Switching between the Sign up and Sign in screens, and going back with the arrow button, uses a fade-and-slide page transition.
