import 'dart:io';
import 'package:path/path.dart' as p;

class SigningKeyGenerator {
  static Future<void> run() async {
    final currentDir = Directory.current.path;
    final androidDir = Directory(p.join(currentDir, 'android'));

    if (!androidDir.existsSync()) {
      print('Error: No "android" directory found in the current directory.');
      print('Please run this command from the root of your Flutter or Android project.');
      exit(1);
    }

    print('Checking for signing keys in: ${androidDir.path}...');

    final isWindows = Platform.isWindows;
    final gradlewName = isWindows ? 'gradlew.bat' : 'gradlew';
    final gradlewFile = File(p.join(androidDir.path, gradlewName));

    if (!gradlewFile.existsSync()) {
      print('Error: "$gradlewName" not found in the android directory.');
      exit(1);
    }

    // Set executable permission on Unix-like systems
    if (!isWindows) {
      await Process.run('chmod', ['+x', gradlewFile.path]);
    }

    print('Running ./gradlew signingReport...');

    final result = await Process.start(
      gradlewFile.path,
      ['signingReport'],
      workingDirectory: androidDir.path,
      runInShell: true,
    );

    // Stream the output
    await stdout.addStream(result.stdout);
    await stderr.addStream(result.stderr);

    final exitCode = await result.exitCode;
    if (exitCode == 0) {
      print('\nSuccessfully generated signing report!');
    } else {
      print('\nFailed to generate signing report. Exit code: $exitCode');
    }
  }
}
