# generate_signin_key

A simple command-line tool for Flutter/Android developers to quickly view their Android signing keys (SHA-1 and SHA-256).

## Installation

Add this to your `pubspec.yaml` as a dev dependency:

```yaml
dev_dependencies:
  generate_signin_key: ^1.0.0
```

Or install it globally:

```bash
dart pub global activate generate_signin_key
```

## Usage

Run the following command in the root of your Flutter/Android project:

```bash
dart run generate_signin_key
```

If installed globally:

```bash
generate_signin_key
```

## Features

- Automatically detects the `android` directory.
- Runs the `./gradlew signingReport` task.
- Works on Windows, macOS, and Linux.
- Streams real-time output from the Gradle task.

## Why use this?

Instead of navigating to the `android` folder and remembering the `./gradlew signingReport` command, you can just run this simple command from your project root. This is especially useful for setting up Firebase, Google Sign-In, and other services that require SHA finger prints.

## License

MIT
