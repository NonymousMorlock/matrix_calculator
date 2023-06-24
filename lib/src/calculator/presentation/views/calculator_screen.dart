import 'package:flutter/material.dart';
import 'package:matrix_calculate/core/enums/matrix_operations.dart';
import 'package:matrix_calculate/src/calculator/domain/entities/variable.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_controller.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_operation_controller.dart';
import 'package:matrix_calculate/src/calculator/presentation/widgets/button_text.dart';
import 'package:matrix_calculate/src/calculator/presentation/widgets/matrix_box.dart';
import 'package:matrix_calculate/src/calculator/presentation/widgets/side_rail.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final breakpoint = ResponsiveBreakpoints.of(context);
    return Consumer<MatrixOperationController>(
      builder: (_, controller, __) {
        return Scaffold(
          appBar: breakpoint.largerThan(TABLET) ? null : AppBar(),
          body: Row(
            children: [
              if (breakpoint.largerThan(TABLET))
                const Expanded(
                  flex: 2,
                  child: SideRail(),
                ),
              Expanded(
                flex: breakpoint.largerThan(TABLET) ? 7 : 1,
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                                controller.matrixControllers.length, (index) {
                              final matrixController =
                                  controller.matrixControllers[index + 1]!;
                              final operation =
                                  controller.operations.length > index
                                      ? controller.operations[index]
                                      : null;
                              return Row(
                                children: [
                                  MatrixBox(
                                    controller: matrixController,
                                  ),
                                  if (operation != null) ...[
                                    const SizedBox(width: 20),
                                    Text(
                                      operation.symbol,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 9),
                                  ],
                                ],
                              );
                            }),
                            if (controller.result != null) ...[
                              const SizedBox(width: 20),
                              const Text(
                                '=',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Text(
                                controller.result!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (controller.resultMatrix != null) ...[
                                const SizedBox(width: 9),
                                IconButton(
                                  onPressed: () => controller.addVariable(
                                    Variable.fromController(
                                      MatrixController.fromMatrix(
                                        controller.resultMatrix!,
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.open_in_new,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: breakpoint.largerThan(TABLET)
                                ? 180
                                : breakpoint.equals(TABLET)
                                    ? 150
                                    : 100,
                          ),
                          padding: EdgeInsets.zero,
                          itemCount: Operation.values.length + 1,
                          itemBuilder: (context, index) {
                            final operation = index == Operation.values.length
                                ? null
                                : Operation.values[index];
                            final symbol =
                                operation == null ? '=' : operation.symbol;
                            return GestureDetector(
                              onTap: operation == null
                                  ? controller.calculate
                                  : () => controller.addOperation(operation),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: ResponsiveValue<Widget>(
                                    context,
                                    conditionalValues: [
                                      Condition.largerThan(
                                        name: MOBILE,
                                        value: ButtonText(text: symbol),
                                      ),
                                      Condition.equals(
                                        name: MOBILE,
                                        value: ButtonText.fitted(
                                          text: symbol,
                                        ),
                                      ),
                                      Condition.smallerThan(
                                        name: MOBILE,
                                        value: ButtonText.fitted(
                                          text: symbol,
                                        ),
                                      )
                                    ],
                                  ).value,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: breakpoint.largerThan(TABLET) ? null : const SideRail(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: controller.addMatrix,
            label: const Text('Add Matrix'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
