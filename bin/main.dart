///
/// Programa de ejemplo de uso de la libreria csp
///
import 'package:args/args.dart';
import 'sample/csp_map_sample.dart';
import 'sample/csp_gantt_sample.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'example',
      abbr: 'e',
      negatable: false,
      help: 'Show example n',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart csp.dart <flags> [arguments]');
  print(argParser.usage);
}

void showSample(String id) {
  switch (id) {
    case '1':
      showMapSample();
      break;
    case '2':
      showGanttSample();
      break;
    default:
      print("Invalid example number");
      break;
  }
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('csp version: $version');
      return;
    }
    if (results.wasParsed('example')) {
      if (results.rest.isNotEmpty) {
        showSample(results.rest[0]);
        return;
      } else {
        print('Missing example id');
      }
    }

    // Act on the arguments provided.
    print('Arguments: ${results.rest}');
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
