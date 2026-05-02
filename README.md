# generate_signin_key

<p align="center">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
</p>

A powerful and simple command-line tool for Flutter and Android developers to quickly generate, view, and save Android signing reports (SHA-1, SHA-256, MD5). No more navigating into the `android` folder or remembering complex Gradle commands!

---

## 🚀 Features

- **Auto-Detection**: Automatically finds the `android` directory in your project root.
- **Gradle Integration**: Executes the `./gradlew signingReport` task seamlessly.
- **Multiple Output Formats**: View results in the terminal or save them to a file.
- **Clean Build**: Option to run `gradlew clean` before generating keys to ensure accuracy.
- **Cross-Platform**: Works perfectly on Windows, macOS, and Linux.
- **Real-time Streaming**: See the Gradle progress as it happens.

---

## 📦 Installation

### As a Dev Dependency
Add this to your project's `pubspec.yaml`:

```yaml
dev_dependencies:
  generate_signin_key: ^1.0.0
```

### Global Installation
Install it globally to use it in any project:

```bash
dart pub global activate generate_signin_key
```

---

## 🛠️ Usage

### Quick Start
Run this command in the root of your Flutter or Android project:

```bash
dart run generate_signin_key
```

### Options & Flags

| Option | Shorthand | Description | Example |
| :--- | :--- | :--- | :--- |
| `--output` | `-o` | Save the report to a specific file. | `--output keys.txt` |
| `--clean` | `-c` | Run `gradlew clean` before the report. | `--clean` |
| `--help` | `-h` | Show the help menu. | `--help` |

### Detailed Examples

**Save to a custom path:**
```bash
dart run generate_signin_key --output ./logs/signing_keys.txt
```

**Perform a clean build and view report:**
```bash
dart run generate_signin_key -c
```

**Run using global activation:**
```bash
generate_signin_key
```

---

## 📖 How it works

1. The tool checks for an `android` directory in your current working directory.
2. It identifies the appropriate Gradle wrapper (`gradlew` or `gradlew.bat`).
3. It grants execution permissions (on Unix systems) and runs the `signingReport` task.
4. It captures and streams the output, optionally writing it to a file if requested.

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 💖 Sponsors

If you find this tool helpful, consider supporting its development!

<a href="https://github.com/sponsors/KANAGARAJ-M">
  <img src="https://img.shields.io/badge/Sponsor-GitHub-ea4aaa?style=for-the-badge&logo=github-sponsors" alt="Sponsor" />
</a>

<br/>

<iframe src="https://github.com/sponsors/KANAGARAJ-M/button" title="Sponsor KANAGARAJ-M" height="32" width="114" style="border: 0; border-radius: 6px;"></iframe>

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Developed with ❤️ by <a href="https://github.com/KANAGARAJ-M">KANAGARAJ M</a>
</p>
