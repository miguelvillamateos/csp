import 'dart:collection';
import 'dart:math';

import '../../csp.dart';

class CspTreeSolver<VAR extends CspVariable, VAL> extends CspSolver<VAR, VAL> {
  @override
  CspAssignment<VAR, VAL> solve(Csp<VAR, VAL> csp) {
    CspAssignment<VAR, VAL> assignment = CspAssignment();
    if (csp.variables.isNotEmpty) {
      int index = Random().nextInt(csp.variables.length);
      VAR root = csp.variables[index];

      List<VAR> orderedVars = [];
      LinkedHashMap<VAR, CspConstraint<VAR, VAL>> parentConstraints =
          LinkedHashMap();

      topologicalSort(csp, root, orderedVars, parentConstraints);
      if (csp.getDomain(root).values.isNotEmpty) {
        for (int i = orderedVars.length - 1; i > 0; i--) {
          VAR variable = orderedVars[i];
          if (parentConstraints.containsKey(variable)) {
            CspConstraint<VAR, VAL>? constraint = parentConstraints[variable];
            if (constraint != null) {
              VAR? parent = csp.getNeighbor(variable, constraint);
              if (parent != null) {
                if (makeArcConsistent(parent, variable, constraint, csp)) {
                  fireStateChanged(csp, null, parent, "makeArcConsistent");
                  if (!csp.getDomain(parent).isEmpty()) {
                    for (VAR variable in orderedVars) {
                      for (VAL value in csp.getDomain(variable).values) {
                        assignment.add(variable, value);
                        if (assignment
                            .isConsistent(csp.getConstraints(variable))) {
                          fireStateChanged(
                              csp, assignment, variable, "Consistent");
                          break;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return assignment;
  }

  void topologicalSort(Csp<VAR, VAL> csp, VAR root, List<VAR> orderedVars,
      Map<VAR, CspConstraint<VAR, VAL>> parentConstraints) {
    orderedVars.add(root);
    parentConstraints.putIfAbsent(root, () => CspConstraint<VAR, VAL>());
    int currParentIdx = -1;
    while (currParentIdx < orderedVars.length - 1) {
      currParentIdx++;
      VAR currParent = orderedVars[currParentIdx];
      int arcsPointingUpwards = 0;
      for (CspConstraint<VAR, VAL> constraint
          in csp.getConstraints(currParent)) {
        VAR? neighbor = csp.getNeighbor(currParent, constraint);
        if (neighbor == null) {
          throw FormatException("Constraint $constraint is not binary.");
        }
        if (parentConstraints.containsKey(neighbor)) {
          arcsPointingUpwards++;
          if (arcsPointingUpwards > 1) {
            throw FormatException("Csp is not tree-structured.");
          }
        } else {
          orderedVars.add(neighbor);
          parentConstraints.putIfAbsent(neighbor, () => constraint);
        }
      }
    }
    if (orderedVars.length < csp.variables.length) {
      throw FormatException("Constraint graph is not connected.");
    }
  }

  bool makeArcConsistent(
      VAR xi, VAR xj, CspConstraint<VAR, VAL> constraint, Csp<VAR, VAL> csp) {
    CspDomain<VAL> currDomain = csp.getDomain(xi);
    List<VAL> newValues = [];
    CspAssignment<VAR, VAL> assignment = CspAssignment();
    for (VAL vi in currDomain.values) {
      assignment.add(xi, vi);
      for (VAL vj in csp.getDomain(xj).values) {
        assignment.add(xj, vj);
        if (constraint.isSatisfiedWith(assignment)) {
          newValues.add(vi);
          break;
        }
      }
    }
    if (newValues.length < currDomain.size) {
      csp.setDomain(xi, CspDomain(values: newValues));
      return true;
    }
    return false;
  }
}
