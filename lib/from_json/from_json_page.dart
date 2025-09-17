import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/extensions.dart';
import 'package:wo_form_example/utils/readable_json.dart';

class FromJsonPage extends StatelessWidget {
  const FromJsonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        titleText: 'Import de formulaire',
        submitMode: StandardSubmitMode(
          submitText: 'Ouvrir le formulaire',
        ),
        disableSubmitMode: DisableSubmitButton.whenInvalid,
      ),
      children: const [
        StringInput(
          id: 'json',
          isRequired: true,
          uiSettings: StringInputUiSettings(
            maxLines: 20,
            hintText: 'Copiez ici le formulaire en format json.',
          ),
        ),
      ],
      onSubmitSuccess: (context) {
        final jsonString =
            context.read<WoFormValuesCubit>().state['/json'] as String?;
        if (jsonString == null) return;

        final Map<String, dynamic> json;
        try {
          json = jsonDecode(jsonString) as Map<String, dynamic>;
        } catch (e) {
          showErrorDialog(
            context,
            'Failed to decode json',
            e,
          );
          return;
        }

        final RootNode root;
        try {
          root = RootNode.fromJson(json);
        } catch (e) {
          showErrorDialog(
            context,
            'Failed to build WoForm from json',
            e,
          );
          return;
        }

        context.pushPage(
          WoForm.root(
            root: root,
            onSubmitSuccess: showJsonDialog,
          ),
        );
      },
    );
  }

  void showErrorDialog(
    BuildContext context,
    String title,
    Object error,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(error.toString()),
          actions: [
            FilledButton.tonal(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
