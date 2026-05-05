import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';

class SigningKeyGenerator {
  static Future<void> run(List<String> arguments) async {
    final parser = ArgParser()
      ..addOption('output',
          abbr: 'o',
          help: 'Save the output to a specific file (e.g., signing_keys.txt).')
      ..addFlag('clean',
          abbr: 'c',
          help: 'Run gradlew clean before generating the report.',
          negatable: false)
      ..addFlag('new',
          abbr: 'n',
          help: 'Generate a new release keystore using keytool.',
          negatable: false)
      ..addFlag('help',
          abbr: 'h', help: 'Show this help message.', negatable: false);

    ArgResults argResults;
    try {
      argResults = parser.parse(arguments);
    } catch (e) {
      print('Error: ${e.toString()}');
      printUsage(parser);
      exit(1);
    }

    if (argResults['help'] as bool) {
      printUsage(parser);
      return;
    }

    if (argResults['new'] as bool) {
      await _generateNewKey();
      return;
    }

    final currentDir = Directory.current.path;
    final androidDir = Directory(p.join(currentDir, 'android'));

    if (!androidDir.existsSync()) {
      print('Error: No "android" directory found in the current directory.');
      print(
          'Please run this command from the root of your Flutter or Android project.');
      exit(1);
    }

    final isWindows = Platform.isWindows;
    final gradlewName = isWindows ? 'gradlew.bat' : 'gradlew';
    final gradlewFile = File(p.join(androidDir.path, gradlewName));

    if (!gradlewFile.existsSync()) {
      print('Error: "$gradlewName" not found in the android directory.');
      exit(1);
    }

    if (!isWindows) {
      await Process.run('chmod', ['+x', gradlewFile.path]);
    }

    if (argResults['clean'] as bool) {
      print('Running ./gradlew clean...');
      final cleanResult = await Process.run(
        gradlewFile.path,
        ['clean'],
        workingDirectory: androidDir.path,
        runInShell: true,
      );
      if (cleanResult.exitCode != 0) {
        print('Error: Clean failed.');
        print(cleanResult.stderr);
        exit(1);
      }
    }

    print('Running ./gradlew signingReport...');

    final process = await Process.start(
      gradlewFile.path,
      ['signingReport'],
      workingDirectory: androidDir.path,
      runInShell: true,
    );

    final List<int> outputBuffer = [];

    // Listen to stdout and stderr
    process.stdout.listen((data) {
      stdout.add(data);
      outputBuffer.addAll(data);
    });

    process.stderr.listen((data) {
      stderr.add(data);
      outputBuffer.addAll(data);
    });

    final exitCode = await process.exitCode;

    if (exitCode == 0) {
      print('\nSuccessfully generated signing report!');

      final outputOption = argResults['output'] as String?;
      if (outputOption != null || arguments.contains('--output')) {
        final filePath = outputOption ?? 'signing_report.txt';
        final outputFile = File(p.join(currentDir, filePath));

        try {
          await outputFile.writeAsBytes(outputBuffer);
          print('Report saved to: ${outputFile.path}');
        } catch (e) {
          print('Error saving report to file: $e');
        }
      }
    } else {
      print('\nFailed to generate signing report. Exit code: $exitCode');
    }
  }

  static Future<void> _generateNewKey() async {
    print('\n--- Generate New Release Keystore ---');

    stdout.write('Enter keystore name (default: upload-keystore.jks): ');
    String? name = stdin.readLineSync();
    if (name == null || name.isEmpty) name = 'upload-keystore.jks';
    if (!name.endsWith('.jks')) name += '.jks';

    stdout.write('Enter keystore password (min 6 chars): ');
    String? password = stdin.readLineSync();
    if (password == null || password.length < 6) {
      print('Error: Password must be at least 6 characters.');
      return;
    }

    stdout.write('Enter alias (default: upload): ');
    String? alias = stdin.readLineSync();
    if (alias == null || alias.isEmpty) alias = 'upload';

    final currentDir = Directory.current.path;
    final androidDir = Directory(p.join(currentDir, 'android'));
    String targetPath;

    if (androidDir.existsSync()) {
      targetPath = p.join(androidDir.path, 'app', name);
      print('Target location: android/app/$name');
    } else {
      targetPath = p.join(currentDir, name);
      print('Target location: $name');
    }

    if (File(targetPath).existsSync()) {
      stdout.write('File already exists. Overwrite? (y/N): ');
      final response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y') {
        print('Aborted.');
        return;
      }
    }

    print('\nGenerating keystore...');

    final process = await Process.run(
      'keytool',
      [
        '-genkey',
        '-v',
        '-keystore',
        targetPath,
        '-alias',
        alias,
        '-keyalg',
        'RSA',
        '-keysize',
        '2048',
        '-validity',
        '10000',
        '-storepass',
        password,
        '-keypass',
        password,
        '-dname',
        'CN=Android, OU=Development, O=NoCorps, L=Unknown, ST=Unknown, C=US',
      ],
      runInShell: true,
    );

    if (process.exitCode == 0) {
      print('\n✅ Success! Keystore generated at: $targetPath');
      print('\nAdd the following to your android/key.properties (create if missing):');
      print('storePassword=$password');
      print('keyPassword=$password');
      print('keyAlias=$alias');
      print('storeFile=${androidDir.existsSync() ? name : targetPath}');
    } else {
      print('\n❌ Error generating keystore:');
      print(process.stderr);
      print(process.stdout);
    }
  }

  static void printUsage(ArgParser parser) {
    print('Usage: generate_signin_key [options]');
    print(parser.usage);
  }
}
