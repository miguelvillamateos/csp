import 'package:args/args.dart';
import 'core/csp.dart';
import 'core/solvers/inference/csp_heuristics.dart';
import 'core/solvers/inference/csp_least_constraining_value_heuristic.dart';
import 'core/solvers/inference/csp_minimum_remaining_values_heuristic.dart';
import 'core/solvers/inference/csp_flexible_backtracking_solver.dart';
import 'core/solvers/inference/strategies/csp_ac3_strategy.dart';

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
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
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

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('csp version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    ///    Ejemplo del coloreado de mapa

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

    Domain<String> domain = Domain<String>(values: [RED, GREEN, BLUE]);

    final Csp<Variable, String> csp =
        Csp<Variable, String>(variables: [NT, SA, V, T, NSW, Q, WA]);

    for (Variable variable in csp.variables) {
      csp.setDomain(variable, domain);
      csp.addConstraint(NotEqualConstraint<Variable, String>(WA, NT));
      csp.addConstraint(NotEqualConstraint<Variable, String>(WA, SA));
      csp.addConstraint(NotEqualConstraint<Variable, String>(NT, SA));
      csp.addConstraint(NotEqualConstraint<Variable, String>(NT, Q));
      csp.addConstraint(NotEqualConstraint<Variable, String>(SA, Q));
      csp.addConstraint(NotEqualConstraint<Variable, String>(SA, NSW));
      csp.addConstraint(NotEqualConstraint<Variable, String>(SA, V));
      csp.addConstraint(NotEqualConstraint<Variable, String>(Q, NSW));
      csp.addConstraint(NotEqualConstraint<Variable, String>(NSW, V));
    }

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
    print(" ---> ");
    print(solution.toString());
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
