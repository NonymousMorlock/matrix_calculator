import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MatrixController extends ChangeNotifier {
  MatrixController();

  MatrixController.fromMatrix(Matrix matrix) {
    _controllers.clear();
    for (var i = 0; i < matrix.matrix.length; i++) {
      _controllers.add([]);
      for (var j = 0; j < matrix.matrix[i].length; j++) {
        _controllers[i]
            .add(TextEditingController(text: matrix.matrix[i][j].toString()));
      }
    }
    row = matrix.matrix.length;
    column = matrix.matrix[0].length;
  }

  int row = 1;
  int column = 1;

  final List<List<TextEditingController>> _controllers = [
    [TextEditingController()],
  ];

  List<List<TextEditingController>> get controllers => _controllers;

  Matrix? get matrix {
    // if any controller's text is empty, return null
    for (var i = 0; i < row; i++) {
      for (var j = 0; j < column; j++) {
        if (_controllers[i][j].text.isEmpty) {
          return null;
        }
      }
    }
    final matrix = <List<int>>[];
    for (var i = 0; i < row; i++) {
      matrix.add([]);
      for (var j = 0; j < column; j++) {
        matrix[i].add(int.parse(_controllers[i][j].text));
      }
    }
    return Matrix(matrix);
  }

  void refresh() {
    notifyListeners();
  }

  void addRow() {
    row++;
    // add a new row of __controllers
    _controllers.add(
      List.generate(
        column,
        (index) => TextEditingController(),
      ),
    );
    notifyListeners();
  }

  void removeRow() {
    row--;
    // remove the last row of _controllers
    _controllers.removeAt(row);
    notifyListeners();
  }

  void addColumn() {
    column++;
    // add a new column of _controllers
    for (var i = 0; i < row; i++) {
      _controllers[i].add(TextEditingController());
    }
    notifyListeners();
  }

  void removeColumn() {
    column--;
    // remove the last column of _controllers
    for (var i = 0; i < row; i++) {
      _controllers[i].removeAt(column);
    }
    notifyListeners();
  }
}
