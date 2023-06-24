import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_controller.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class MatrixBox extends StatelessWidget {
  const MatrixBox({
    this.controller,
    super.key,
  }) : small = false;

  const MatrixBox.small({
    this.controller,
    super.key,
  }) : small = true;

  final MatrixController? controller;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final borderSide = BorderSide(
      color: Theme.of(context).primaryColor,
      width: 2,
    );
    // build rows and columns
    return ChangeNotifierProvider(
      create: (_) => controller ?? MatrixController(),
      child: Builder(
        builder: (context) {
          return Consumer<MatrixController>(
            builder: (_, controller, __) {
              final box = IntrinsicHeight(
                child: Stack(
                  children: [
                    SizedBox(
                      width: small
                          ? null
                          : ResponsiveBreakpoints.of(context)
                                  .largerThan('TABLET')
                              ? (controller.column > 3
                                  ? screenSize.width * 0.4
                                  : controller.column > 2
                                      ? screenSize.width * 0.3
                                      : controller.column > 1
                                          ? screenSize.width * 0.2
                                          : screenSize.width * 0.1)
                              : (controller.column > 2
                                  ? screenSize.width * 0.8
                                  : controller.column > 1
                                      ? screenSize.width * 0.6
                                      : screenSize.width * 0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.row,
                          (rowIndex) => Row(
                            children: List.generate(
                              controller.column,
                              (columnIndex) {
                                final valueController = controller
                                    .controllers[rowIndex][columnIndex];
                                if (small) {
                                  valueController
                                      .addListener(controller.refresh);
                                }
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: small
                                        ? Text(
                                            valueController.text,
                                            textAlign: TextAlign.center,
                                          )
                                        : TextField(
                                            controller: valueController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            inputFormatters: [
                                              // numbers, negative sign,
                                              // decimal point
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.\-]'),
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            right: borderSide,
                            bottom: borderSide,
                            top: borderSide,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            left: borderSide,
                            bottom: borderSide,
                            top: borderSide,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
              return small
                  ? box
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: controller.addRow,
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: controller.removeRow,
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: controller.addColumn,
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: controller.removeColumn,
                                  icon: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                            box,
                          ],
                        ),
                      ],
                    );
            },
          );
        },
      ),
    );
  }
}
