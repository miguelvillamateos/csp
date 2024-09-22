import '../../../csp.dart';
import '../csp_inference_log.dart';

abstract class AbstractInferenceStrategy<VAR extends Variable, VAL> {
  const AbstractInferenceStrategy();
  InferenceLog<VAR, VAL> initialApply(Csp<VAR, VAL> csp);

  InferenceLog<VAR, VAL> apply(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable);
}
