import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/edit_event/event.dart';
import 'package:wo_form_example/edit_event/event_page.dart';

class EditEventPage extends StatelessWidget {
  const EditEventPage({
    required this.event,
    required this.eventsCubit,
    super.key,
  });

  final EventModel event;
  final EventsCubit eventsCubit;

  @override
  Widget build(BuildContext context) {
    final rootKey = RootKey();
    return WoForm(
      rootKey: rootKey,
      uiSettings: WoFormUiSettings(
        submitMode: const StandardSubmitMode(
          submitText: 'Save',
          disableSubmitMode: DisableSubmitButton.whenInitialOrSubmitSuccess,
          buttonPosition: SubmitButtonPosition.appBar,
        ),
        canQuit: (context) async => context.read<WoFormValuesCubit>().isPure ||
                context.read<WoFormStatusCubit>().state is SubmitSuccessStatus
            ? true
            : showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title:
                        const Text('Abandonner les modifications en cours ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text("Continuer d'éditer"),
                      ),
                      FilledButton.tonal(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text('Quitter'),
                      ),
                    ],
                  );
                },
              ),
      ),
      children: [
        WidgetNode(builder: (_) => const SizedBox(height: 32)),
        StringInput(
          id: 'title',
          initialValue: event.title,
          isRequired: true,
          uiSettings: StringInputUiSettings(
            labelText: 'Title',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        StringInput(
          id: 'address',
          initialValue: event.address,
          uiSettings: const StringInputUiSettings(
            labelText: 'Address',
            placeAutocompleteType: PlaceType.address,
            placeAutocompleteCountries: ['fr'],
            action: StringFieldAction.clear,
          ),
        ),
        WidgetNode(builder: (_) => const SizedBox(height: 32)),
        DateTimeInput(
          id: 'start',
          isRequired: true,
          initialValue: FixedDateTime(date: event.start),
          uiSettings: const DateTimeInputUiSettings(
            dateFormat: 'E, MMMM d, y',
            initialDatePickerMode: DatePickerMode.year,
          ),
        ),
        DateTimeInput(
          id: 'finish',
          isRequired: true,
          initialValue: FixedDateTime(date: event.finish),
          getCustomError: (value, path) {
            if (value == null) return EmptyInputError(path: path);
            final start = rootKey.values?['/start'];
            if (start is! DateTime) return null;

            if (value.isBefore(start)) {
              return CustomInputError(
                path: path,
                message: 'The finish date must be after the start date.',
              );
            }

            return null;
          },
          uiSettings: const DateTimeInputUiSettings(
            dateFormat: 'E, MMMM d, y',
            initialDatePickerMode: DatePickerMode.year,
          ),
        ),
      ],
      onSubmitting: (form, values) async {
        final edittedEvent = event.copyWith(
          title: values['/title'] as String,
          address: values['/address'] as String?,
          start: values['/start'] as DateTime,
          finish: values['/finish'] as DateTime,
        );
        eventsCubit.update(event: edittedEvent);
      },
      onSubmitSuccess: (context) => Navigator.of(context).pop(),
    );
  }
}
