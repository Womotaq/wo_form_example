import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/readable_json.dart';

class InteractiveStoryPage extends StatelessWidget {
  const InteractiveStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: WoFormUiSettings(
        submitButtonBuilder: (data) => data.path.contains('garden')
            ? Align(
                alignment: Alignment.centerRight,
                child: SubmitButton(data.copyWith(path: '/')),
              )
            : const SizedBox.shrink(),
        submitMode: MultiStepSubmitMode(
          nextText: 'Quit',
          getNextStep: (stepId, values) {
            final choice = values['/$stepId/choice'] as List<StoryStep>? ?? [];
            return choice.firstOrNull?.name;
          },
        ),
      ),
      children: StoryStep.values.map(StoryStepNode.new).toList(),
      onSubmitSuccess: (context) async {
        await showJsonDialog(context);
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}

enum StoryStep {
  entry,
  kitchen,
  bedroom,
  bathroom,
  toilets,
  garden;

  factory StoryStep.fromString(String name) =>
      values.firstWhere((value) => value.name == name);

  List<StoryStep> get nextSteps => switch (this) {
        entry => [kitchen, bedroom],
        kitchen => [],
        bedroom => [bathroom, toilets],
        bathroom => [],
        toilets => [garden],
        garden => [],
      };

  String get endText => switch (this) {
        entry => '',
        kitchen => 'You found a spoon and a yogurt. Bon appétit !',
        bedroom => '',
        bathroom => 'Nothing here.',
        toilets => '',
        garden => "You're free to go !",
      };
}

class StoryStepNode extends InputsNode {
  StoryStepNode(StoryStep step)
      : super(
          id: step.name,
          uiSettings: InputsNodeUiSettings(
            labelText: 'You are in the ${step.name}.',
          ),
          children: [
            if (step.nextSteps.isNotEmpty)
              SelectInput(
                id: 'choice',
                maxCount: 1,
                minCount: 1,
                submitFormOnSelect: true,
                availibleValues: step.nextSteps,
                uiSettings: SelectInputUiSettings<StoryStep>(
                  valueBuilder: (step) => Text(
                    step == null ? 'Select a step' : 'Go to the ${step.name}',
                  ),
                ),
              ),
            WidgetNode(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(step.endText),
              ),
            ),
          ],
        );
}
