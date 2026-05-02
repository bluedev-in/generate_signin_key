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
      ..addFlag('help', abbr: 'h', help: 'Show this help message.', negatable: false);

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

    final currentDir = Directory.current.path;
    final androidDir = Directory(p.join(currentDir, 'android'));

    if (!androidDir.existsSync()) {
      print('Error: No "android" directory found in the current directory.');
      print('Please run this command from the root of your Flutter or Android project.');
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
        // Use default name if only flag provided without value (though option requires value in args package)
        // If the user wants a default, we should have used a flag or a default value.
        // Let's assume they want a default if they use the option.
        
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

  static void printUsage(ArgParser parser) {
    print('Usage: generate_signin_key [options]');
    print(parser.usage);
  }
}
