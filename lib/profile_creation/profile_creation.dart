import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/discard_changes_dialog.dart';
import 'package:wo_form_example/utils/readable_json.dart';
import 'package:wo_form_example/utils/regex_pattern.dart';

class ProfileCreationPage extends StatelessWidget {
  const ProfileCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        submitMode: PageByPageSubmitMode(
          submitText: 'Save',
          nextText: 'Next',
          showProgressIndicator: false,
        ),
        canQuit: showDiscardChangesDialogIfWoFormUnsaved,
      ),
      children: [
        InputsNode(
          id: 'namePage',
          uiSettings: const InputsNodeUiSettings(
            labelText: "Comment t'appelles-tu ?",
          ),
          children: [
            const StringInput(
              id: 'firstName',
              isRequired: true,
              uiSettings: StringInputUiSettings(
                labelText: 'Prénom',
                hintText: "N'écris pas John stp !!",
                prefixIcon: Icon(Icons.person),
                autofocus: true,
                autofillHints: [AutofillHints.givenName],
              ),
            ),
            ConditionnalNode(
              id: 'condition',
              condition: ConditionValue(
                path: '/namePage/firstName',
                isEqualTo: 'John',
              ),
              child: const StringInput(
                id: 'password',
                isRequired: true,
                uiSettings: StringInputUiSettings(
                  labelText: 'Bonjour agent John.',
                  hintText: 'Mot de passe',
                  prefixIcon: SizedBox.square(dimension: 24),
                ),
              ),
            ),
            const StringInput(
              id: 'lastName',
              uiSettings: StringInputUiSettings(
                labelText: 'Nom',
                prefixIcon: SizedBox.square(dimension: 24),
                autofillHints: [AutofillHints.familyName],
              ),
            ),
          ],
        ),
        const InputsNode(
          id: 'addressPage',
          uiSettings: InputsNodeUiSettings(
            labelText: 'Où habites-tu ?',
          ),
          children: [
            StringInput(
              id: 'street',
              uiSettings: StringInputUiSettings(
                labelText: 'Rue',
                prefixIcon: Icon(Icons.location_on),
                autofocus: true,
                autofillHints: [AutofillHints.streetAddressLevel1],
              ),
            ),
            StringInput(
              id: 'postalCode',
              uiSettings: StringInputUiSettings(
                labelText: 'Code postal',
                prefixIcon: SizedBox.square(dimension: 24),
                keyboardType: TextInputType.number,
                autofillHints: [AutofillHints.postalCode],
              ),
            ),
            StringInput(
              id: 'city',
              uiSettings: StringInputUiSettings(
                labelText: 'Ville',
                prefixIcon: SizedBox.square(dimension: 24),
                autofillHints: [AutofillHints.addressCity],
              ),
            ),
            StringInput(
              id: 'country',
              initialValue: 'France',
              uiSettings: StringInputUiSettings(
                labelText: 'Pays',
                prefixIcon: Icon(Icons.public),
                autofillHints: [AutofillHints.countryName],
              ),
            ),
          ],
        ),
        InputsNode(
          id: 'contactPage',
          uiSettings: const InputsNodeUiSettings(
            labelText: 'Comment te contacter ?',
          ),
          children: [
            StringInput(
              id: 'mail',
              isRequired: true,
              regexPattern: RegexPattern.email.value,
              uiSettings: StringInputUiSettings.email(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.mail),
                autofocus: true,
                invalidRegexMessage: 'Ne correspond pas à une adresse email',
              ),
            ),
            StringInput(
              id: 'phone',
              initialValue: 'nawak',
              uiSettings: StringInputUiSettings.phone(
                labelText: 'Numéro de téléphone',
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
          ],
        ),
      ],
      onSubmitting: (form, values) async {
        if (values['/namePage/firstName'] == 'John') {
          throw ArgumentError("On t'avais dit de ne pas écrire John...");
        }
      },
      onSubmitSuccess: showJsonDialog,
    );
  }
}
