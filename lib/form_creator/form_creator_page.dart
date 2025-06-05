import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/form_creator/num_input_node.dart';
import 'package:wo_form_example/form_creator/select_string_input_node.dart';
import 'package:wo_form_example/form_creator/string_input_node.dart';
import 'package:wo_form_example/utils/extensions.dart';
import 'package:wo_form_example/utils/readable_json.dart';

class FormCreatorPage extends StatelessWidget {
  const FormCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      showErrors: ShowErrors.always,
      children: [
        const InputsNode(
          id: 'uiSettings',
          uiSettings: InputsNodeUiSettings(
            labelText: 'Paramètres généraux',
            childrenVisibility: ChildrenVisibility.whenAsked,
          ),
          children: [
            StringInput(
              id: 'titleText',
              uiSettings:
                  StringInputUiSettings(labelText: 'Titre du formulaire'),
            ),
            StringInput(
              id: 'submitText',
              uiSettings: StringInputUiSettings(
                labelText: 'Label du bouton de validation',
              ),
            ),
          ],
        ),
        DynamicInputsNode(
          id: 'children',
          exportSettings: const ExportSettings(type: ExportType.list),
          templates: [
            DynamicInputTemplate(
              uiSettings: const DynamicInputUiSettings(
                labelText: 'Choix de texte',
              ),
              child: createSelectStringInputNode(),
            ),
            DynamicInputTemplate(
              uiSettings: const DynamicInputUiSettings(
                labelText: 'Saisie de texte',
              ),
              child: createStringInputNode(),
            ),
            DynamicInputTemplate(
              uiSettings: const DynamicInputUiSettings(
                labelText: 'Saisie de nombre',
              ),
              child: createNumInputNode(),
            ),
          ],
          uiSettings: const DynamicInputsNodeUiSettings(
            labelText: 'Ajouter une saisie',
          ),
        ),
        WidgetNode(
          id: 'jsonClipboarder',
          builder: (_) => const JsonClipboarder(),
        ),
      ],
      uiSettings: WoFormUiSettings(
        titleText: "Création d'un formulaire",
        submitMode: const WoFormSubmitMode.standard(
          buttonPosition: SubmitButtonPosition.appBar,
          disableSubmitMode: DisableSubmitButton.whenInvalid,
        ),
        submitButtonBuilder: (data) => TextButton(
          onPressed: data.onPressed,
          child: const Text('Exporter'),
        ),
        canQuit: (context) async => context.read<WoFormValuesCubit>().isPure ||
                context.read<WoFormStatusCubit>().state is SubmitSuccessStatus
            ? true
            : showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Supprimer le formulaire ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text("Continuer d'éditer"),
                      ),
                      FilledButton.tonal(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text('Supprimer le formulaire'),
                      ),
                    ],
                  );
                },
              ),
      ),
      onSubmitSuccess: (context) async {
        try {
          final root = RootNode.fromJson(
            await context.read<RootNode>().exportToMap(
                  values: context.read<WoFormValuesCubit>().state,
                  context: context,
                ),
          );

          if (context.mounted) {
            await context.pushPage(
              Hero(
                tag: 'createdForm',
                child: WoForm.root(
                  root: root,
                  onSubmitSuccess: showJsonDialog,
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                icon: const Icon(Icons.error),
                content: Text(e.toString()),
              ),
            );
          }
          return;
        }
      },
    );
  }
}

class JsonClipboarder extends StatefulWidget {
  const JsonClipboarder({super.key});

  @override
  State<JsonClipboarder> createState() => _JsonClipboarderState();
}

class _JsonClipboarderState extends State<JsonClipboarder> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    final values = context.watch<WoFormValuesCubit>().state;

    final root = context.read<RootNode>();
    final woFormL10n = context.read<WoFormL10n>();

    final errorsText = woFormL10n.errors(
      root.getErrors(values: values).length,
    );

    return Column(
      children: [
        const SizedBox(height: 32),
        InputHeader(
          WoFormInputHeaderData(
            path: '',
            labelText: 'Prévisualisation',
            trailing: IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () =>
                  context.read<WoFormValuesCubit>().submit(context),
            ),
            shrinkWrap: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: root.exportToMap(
              values: values,
              context: context,
            ),
            builder: (context, snapshot) {
              RootNode? createdRoot;
              try {
                createdRoot = RootNode.fromJson(snapshot.data!);
              } catch (_) {}

              return InputDecorator(
                decoration: InputDecoration(
                  helperText: ' ',
                  errorText: createdRoot == null ? ' ' : null,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(8),
                ),
                child: createdRoot != null
                    ? Hero(
                        tag: 'createdForm',
                        child: Material(
                          child: WoForm.root(
                            key: UniqueKey(),
                            root: createdRoot.copyWith(
                              uiSettings: WoFormUiSettings(
                                submitMode: StandardSubmitMode(
                                  scaffoldBuilder: (body) => body,
                                ),
                              ),
                            ),
                            onSubmitSuccess: showJsonDialog,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$errorsText',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
        ListTile(
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                text: jsonEncode(
                  await root.exportToMap(
                    values: context.read<WoFormValuesCubit>().state,
                    context: context,
                  ),
                ),
              ),
            );
            setState(() => copied = true);
            Future.delayed(
              const Duration(seconds: 4),
              () => setState(() => copied = false),
            );
          },
          leading: copied ? const Icon(Icons.check) : const Icon(Icons.copy),
          title: const Text(
            'Copier le formulaire',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ExpansionTile(
          title: const Text(''),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                return Text(
                  readableJson(
                    root.exportToMap(
                      values: values,
                      context: context,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
