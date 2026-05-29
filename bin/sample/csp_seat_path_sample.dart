import 'package:equatable/equatable.dart';

import '../core/csp.dart';

class PersonModel extends Equatable{
  final int id;
  final String name;

  PersonModel({required this.id, required this.name});

  @override
  List<Object?> get props => [id,name];
}

class SeatModel extends Equatable {
  final int id;
  final int groupId;
  final String name;
  final List<SeatModel> nextTo;

  SeatModel({required this.id, required this.groupId, required this.name,this.nextTo =const []});

  @override
  List<Object?> get props => ['id', 'groupId', 'name','nextTo'];

}

class CspSeatPathVariable extends CspVariable<PersonModel> {
  CspSeatPathVariable({required super.model});
}

class CspSeatPathValue extends CspValue<SeatModel> {
  CspSeatPathValue({required super.model});
}

class CspSeatPathDomain extends CspDomain<CspSeatPathValue> {
  CspSeatPathDomain({required super.values});
}

abstract class CspSeatPathConstraint<VAR extends CspSeatPathVariable, VAL extends CspSeatPathValue>
    extends BinaryConstraint<VAR, VAL> {
  CspSeatPathConstraint(super.v1, super.v2);
}



void showSeatPathSample() {

}