import 'package:flutter_test/flutter_test.dart';
import 'package:matrix_calculate/app/app.dart';
import 'package:matrix_calculate/src/calculator/presentation/views/calculator_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders CalculatorScreen', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CalculatorScreen), findsOneWidget);
    });
  });
}
