import 'package:args/args.dart';
import 'core/csp.dart';

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
      help: 'Show sample n',
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
      showTimetableSample();
      break;
    default:
      print("Invalid example number");
      break;
  }
}

void showTimetableSample() {
  print("---------------------");
  print("Timetable example");
  print("---------------------");

  



}

void showMapSample() {
  ///    Ejemplo del coloreado de mapa

  print("---------------------");
  print("Map coloring example");
  print("---------------------");

  final Variable NSW = Variable(name: "NSW");
  final Variable NT = Variable(name: "NT");
  final Variable Q = Variable(name: "Q");
  final Variable SA = Variable(name: "SA");
  final Variable T = Variable(name: "T");
  final Variable V = Variable(name: "V");
  final Variable WA = Variable(name: "WA");

  final String RED = "RED";
  final String GREEN = "GREEN";
  final String BLUE = "BLUE";
  final String YELLOW = "YELLOW";

  Domain<String> domain = Domain<String>(values: [RED, GREEN, BLUE]);

  final Csp<Variable, String> csp =
      Csp<Variable, String>(variables: [SA, NT, V, T, NSW, Q, WA]);

  for (Variable variable in csp.variables) {
    csp.setDomain(variable, domain);
  }

  csp.addConstraint(NotEqualConstraint<Variable, String>(WA, NT));
  csp.addConstraint(NotEqualConstraint<Variable, String>(WA, SA));
  csp.addConstraint(NotEqualConstraint<Variable, String>(NT, SA));
  csp.addConstraint(NotEqualConstraint<Variable, String>(NT, Q));
  csp.addConstraint(NotEqualConstraint<Variable, String>(SA, Q));
  csp.addConstraint(NotEqualConstraint<Variable, String>(SA, NSW));
  csp.addConstraint(NotEqualConstraint<Variable, String>(SA, V));
  csp.addConstraint(NotEqualConstraint<Variable, String>(Q, NSW));
  csp.addConstraint(NotEqualConstraint<Variable, String>(NSW, V));
  // SA = RED
  csp.setDomain(SA, Domain<String>(values: [RED]));
  csp.setDomain(T, Domain<String>(values: [GREEN]));

  AC3Strategy<Variable, String> ac3strategy = AC3Strategy<Variable, String>();
  MinimumRemainingValuesHeuristic<Variable, String>
      minimumRemainingValuesHeuristic =
      MinimumRemainingValuesHeuristic<Variable, String>();
  LeastConstrainingValueHeuristic<Variable, String>
      leastConstrainingValueHeuristic =
      LeastConstrainingValueHeuristic<Variable, String>();
  Heuristics<Variable, String> heuristics = Heuristics<Variable, String>(
      variableSelectionStrategy: minimumRemainingValuesHeuristic,
      valueOrderingStrategy: leastConstrainingValueHeuristic);

  FlexibleBacktrackingSolver<Variable, String> solver =
      FlexibleBacktrackingSolver(
          heuristics: heuristics, inferenceStrategy: ac3strategy);

  CspListener<Variable, String> listener = CspListener<Variable, String>();

  solver.addCspListener(listener);

  Assignment solution = solver.solve(csp);
  if (solution.isSolution(csp)) {
    print("Solution ---> ${solution.toString()}");
  } else {
    print("Partial solution ---> ${solution.toString()}");
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
        print('Missing example number');
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
