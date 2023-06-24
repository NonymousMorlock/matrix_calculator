import 'package:badges/badges.dart' as bdg;
import 'package:flutter/material.dart';
import 'package:matrix_calculate/src/calculator/presentation/controllers/matrix_operation_controller.dart';
import 'package:matrix_calculate/src/calculator/presentation/widgets/matrix_box.dart';
import 'package:provider/provider.dart';

class SideRail extends StatelessWidget {
  const SideRail({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<MatrixOperationController>(
      builder: (_, controller, __) {
        return Drawer(
          backgroundColor: const Color(0xFFE5E5E5),
          child: Scaffold(
            backgroundColor: const Color(0xFFE5E5E5),
            body: ListView.builder(
              itemCount: controller.sessionVariables.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final variable = controller.sessionVariables[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: bdg.Badge(
                    badgeContent: IconButton(
                      onPressed: () => controller.useVariable(variable),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.open_in_new,
                        color: Colors.deepPurpleAccent,
                        size: 25,
                      ),
                    ),
                    badgeStyle: const bdg.BadgeStyle(
                      badgeColor: Colors.transparent,
                    ),
                    position: bdg.BadgePosition.bottomEnd(
                      bottom: -25,
                      end: width * .1,
                    ),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        child: TextField(
                          controller: TextEditingController(text: variable.name),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            controller.editVariableName(
                              id: variable.id,
                              newName: value,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      title: MatrixBox.small(
                        controller: variable.controller,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.removeVariable(variable);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: controller.sessionVariables.isEmpty
                ? null
                : FloatingActionButton.extended(
                    onPressed: controller.clearVariables,
                    label: const Text('Clear All'),
                    icon: const Icon(Icons.clear),
                  ),
          ),
        );
      },
    );
  }
}
