# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-05-05

### Added
- **Release Key Generation**: Added `--new` (`-n`) flag to generate a new JKS keystore.
- **Interactive Certificate Setup**: Prompts for DName fields (CN, OU, O, L, ST, C) during key generation.
- **Smart Keytool Discovery**: Automatically locates `keytool` in PATH, JAVA_HOME, and Android Studio paths.
- **Credential Export**: Added `--keyexport` to save keystore details to a text file for backup.
- **Instant Key Reporting**: Added `--run` (`-r`) to immediately display SHA-1/SHA-256 keys after generation.
- **Security Warnings**: Integrated prominent warnings about not uploading sensitive keys to public repositories.

## [1.0.0] - 2026-05-02

### Added
- Initial release of `generate_signin_key`.
- Support for generating Android signing reports (SHA-1, SHA-256, MD5).
- CLI options: `--output` (`-o`) for saving reports to a file.
- CLI options: `--clean` (`-c`) for running `gradlew clean` before the report.
- CLI options: `--help` (`-h`) for displaying usage instructions.
- Automatic detection of the `android` directory and Gradle wrapper.
- Cross-platform support (Windows, macOS, Linux).
- Professional README with logos and detailed documentation.
