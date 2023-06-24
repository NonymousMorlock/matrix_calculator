
import 'package:equatable/equatable.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_controller.dart';

class Variable extends Equatable {
  const Variable({
    required this.id,
    required this.name,
    required this.controller,
  });

  const Variable.fromController(MatrixController controller)
      : id = 0,
        name = '0',
        controller = controller;

  final int id;
  final String name;
  final MatrixController controller;

  @override
  List<Object?> get props => [controller.matrix];

  Variable copyWith({
    int? id,
    String? name,
    MatrixController? value,
  }) {
    return Variable(
      id: id ?? this.id,
      name: name ?? this.name,
      controller: value ?? this.controller,
    );
  }
}
