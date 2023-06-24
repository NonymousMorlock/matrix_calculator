import 'package:flutter/cupertino.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_calculate/core/enums/matrix_operations.dart';
import 'package:matrix_calculate/src/calculator/domain/entities/variable.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_controller.dart';

class MatrixOperationController extends ChangeNotifier {
  final Map<int, MatrixController> _matrixControllers = {};

  Map<int, MatrixController> get matrixControllers => _matrixControllers;

  final List<Operation> _operations = [];

  final List<Variable> _sessionVariables = [];

  List<Variable> get sessionVariables => _sessionVariables;

  List<Operation> get operations => _operations;

  String? _result;

  String? get result => _result;

  Matrix? _resultMatrix;

  Matrix? get resultMatrix => _resultMatrix;

  static const List<Operation> _specialOperations = [
    Operation.DETERMINANT,
    Operation.INVERSE,
    Operation.TRANSPOSE,
    Operation.ADJOINT,
    Operation.COFACTOR,
    Operation.RANK,
  ];

  Future<void> addMatrix([MatrixController? controller]) async {
    if (_result != null) clear();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (_matrixControllers.length > _operations.length) return;
    _matrixControllers[_matrixControllers.length + 1] =
        controller ?? MatrixController();
    addVariable(
      Variable(
        id: _sessionVariables.length + 1,
        name: (_sessionVariables.length + 1).toString(),
        controller: _matrixControllers[_matrixControllers.length]!,
      ),
    );

    debugPrint('added matrix: ${_matrixControllers.length}');
    notifyListeners();
  }

  void clear() {
    _matrixControllers.clear();
    _operations.clear();
    _result = null;
    _resultMatrix = null;
    notifyListeners();
    debugPrint('cleared');
  }

  void addOperation(Operation operation) {
    // if the last matrixController's matrix is null, return
    if (_result != null) clear();
    final controller = _matrixControllers[_matrixControllers.length];
    if (controller != null && controller.matrix == null) return;
    if (_operations.length >= _matrixControllers.length) return;
    if (_specialOperations.contains(operation)) {
      switch (operation) {
        case Operation.DETERMINANT:
          _result = controller!.matrix!.determinant.toString();
          notifyListeners();
          return;
        case Operation.INVERSE:
          _result = 'Coming Soon';
          notifyListeners();
          return;
        case Operation.TRANSPOSE:
          _resultMatrix = controller!.matrix!.transpose;
          _result = controller.matrix!.transpose.toString();
          notifyListeners();
          return;
        case Operation.ADJOINT:
          _result = 'Coming Soon';
          notifyListeners();
          return;
        case Operation.COFACTOR:
          _result = 'Coming Soon';
          notifyListeners();
          return;
        case Operation.RANK:
          _result = 'Coming Soon';
          notifyListeners();
          return;
        default:
          return;
      }
    }
    _operations.add(operation);
    debugPrint('added operation: ${operation.symbol}');
    notifyListeners();
  }

  void delete() {
    if (_result != null) clear();
    if (_operations.length > _matrixControllers.length) {
      _operations.removeLast();
      debugPrint('deleted operation');
    } else if (_matrixControllers.isNotEmpty) {
      _matrixControllers.remove(_matrixControllers.length);
      debugPrint('deleted matrix');
    }
  }

  void removeVariable(Variable variable) {
    if (_sessionVariables.contains(variable)) {
      _sessionVariables.remove(variable);
      notifyListeners();
    }
  }

  void addVariable(Variable variable) {
    if (!_sessionVariables.contains(variable)) {
      _sessionVariables.add(variable.copyWith(
        id: _sessionVariables.length + 1,
        name: (_sessionVariables.length + 1).toString(),
      ),);
      notifyListeners();
    }
  }

  void clearVariables() {
    _sessionVariables.clear();
    notifyListeners();
  }

  void useVariable(Variable variable) {
    addMatrix(variable.controller);
  }

  void calculate() {
    if (_operations.isEmpty ||
        _operations.length != _matrixControllers.length - 1) return;

    Matrix? result;
    // sort the matrixControllers by their keys
    final sortedMatrixControllers = _matrixControllers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (var i = 0; i < sortedMatrixControllers.length; i++) {
      final matrixController = sortedMatrixControllers[i].value;
      final matrix = matrixController.matrix;
      if (matrix == null) return;
      if (i == 0) {
        result = matrix;
        continue;
      }
      final operation = _operations[i - 1];
      switch (operation) {
        case Operation.ADD:
          result = result! + matrix;
        case Operation.SUBTRACT:
          result = result! - matrix;
        case Operation.MULTIPLY:
          result = result! * matrix;
        case Operation.DIVIDE:
          result = result! / matrix;
        default:
          return;
      }
    }
    _resultMatrix = result;
    _result = result.toString();
    notifyListeners();
  }

  void editVariableName({required int id, required String newName}) {
    if (_sessionVariables.any((element) => element.id == id)) {
      final variableIndex =
          _sessionVariables.indexWhere((element) => element.id == id);
      _sessionVariables[variableIndex] =
          _sessionVariables[variableIndex].copyWith(name: newName);
      notifyListeners();
    }
  }
}
