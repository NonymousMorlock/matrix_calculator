import 'package:flutter/material.dart';
import 'package:matrix_calculate/l10n/l10n.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_operation_controller.dart';
import 'package:matrix_calculate/src/calculator/presentation/views/calculator_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatrixOperationController(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.deepPurpleAccent,
            primarySwatch: Colors.deepPurple,
          ),
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: ClampingScrollWrapper(child: child!),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CalculatorScreen(),
      ),
    );
  }
}
