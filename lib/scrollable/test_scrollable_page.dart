import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/container_node.dart';
import 'package:wo_form_example/utils/presentation_cubit.dart';

class TestScrollableForm extends WoForm {
  TestScrollableForm(BuildContext context, {super.key})
      : super(
          uiSettings: WoFormUiSettings(
            bodyLayout: WoFormBodyLayout.flexible,
            presentation: context.read<PresentationCubit>().state,
          ),
          children: [
            WoFormNode.valueBuilder(
              id: 'id',
              path: '#scroll',
              builder: (scrollable) {
                return InputsNode(
                  id: 'list',
                  uiSettings: InputsNodeUiSettings(
                    flex: 1,
                    scrollable: scrollable as bool? ?? false,
                  ),
                  children: [
                    const BooleanInput(
                      id: 'scroll',
                      initialValue: true,
                      uiSettings: BooleanInputUiSettings(
                        labelText: 'InputsNodeUiSettings.scrollable',
                      ),
                    ),
                    WidgetNode(
                      builder: (context) => const _CreationTracker(),
                    ),
                    ContainerNode(
                      text: 'flex : unset',
                    ),
                    ContainerNode(
                      flex: 1,
                      color: Colors.orangeAccent,
                      text: 'flex : 1',
                    ),
                    ContainerNode(
                      flex: 2,
                      color: Colors.green,
                      text: 'flex : 2',
                    ),
                    DynamicInputsNode(
                      id: 'dynamic',
                      templates: [
                        DynamicInputTemplate(
                          child: const StringInput(id: 'id'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        );
}

class _CreationTracker extends StatefulWidget {
  const _CreationTracker();

  @override
  State<_CreationTracker> createState() => __CreationTrackerState();
}

class __CreationTrackerState extends State<_CreationTracker> {
  late final DateTime initializedAt;

  @override
  void initState() {
    super.initState();
    initializedAt = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Text(initializedAt.toString());
  }
}
