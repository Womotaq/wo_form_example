import 'package:wo_form/wo_form.dart';

class DynamicInputsForm extends WoForm {
  DynamicInputsForm({super.key})
      : super(
          children: [
            DynamicInputsNode(
              id: 'default',
              templates: template,
              uiSettings: const DynamicInputsNodeUiSettings(
                labelText: 'Default',
                addButtonText: 'Ajouter une entrée',
              ),
            ),
            DynamicInputsNode(
              id: 'defaultMultitemplates',
              templates: templates,
              uiSettings: const DynamicInputsNodeUiSettings(
                labelText: 'Default Multitemplates',
                addButtonText: 'Ajouter une entrée',
              ),
            ),
            DynamicInputsNode(
              id: 'footer',
              templates: template,
              uiSettings: const DynamicInputsNodeUiSettings(
                labelText: 'Footer',
                addButtonText: 'Ajouter une entrée',
                addButtonPosition: DynamicInputsNodeAddButtonPosition.footer,
              ),
            ),
            DynamicInputsNode(
              id: 'footertMultitemplates',
              templates: templates,
              uiSettings: const DynamicInputsNodeUiSettings(
                labelText: 'Footer Multitemplates',
                addButtonText: 'Ajouter une entrée',
                addButtonPosition: DynamicInputsNodeAddButtonPosition.footer,
              ),
            ),
          ],
        );

  static final template = [
    DynamicInputTemplate(
      child: const StringInput(id: 'id'),
    ),
  ];
  static final templates = [
    DynamicInputTemplate(
        child: const StringInput(id: 'id'),
        uiSettings: const DynamicInputUiSettings(
          labelText: 'StringInput',
        )),
    DynamicInputTemplate(
        child: const NumInput(id: 'id'),
        uiSettings: const DynamicInputUiSettings(
          labelText: 'NumInput',
        )),
  ];
}
