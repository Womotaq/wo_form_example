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
    return WoForm(
      uiSettings: WoFormUiSettings(
        titleText: "Édition d'un événement",
        submitMode: const StandardSubmitMode(
          submitText: 'Enregistrer',
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
        StringInput(
          id: 'title',
          initialValue: event.title,
          isRequired: true,
          uiSettings: StringInputUiSettings(
            labelText: 'Titre',
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
            labelText: 'Adresse',
            keyboardType: TextInputType.streetAddress,
            autofillHints: [AutofillHints.addressCity],
          ),
        ),
        DateTimeInput(
          id: 'start',
          isRequired: true,
          initialValue: FixedDateTime(date: event.start),
          minDate: const TodayDate(),
          maxDate: const TodayDate(addYears: 4, replaceMonths: 7),
          uiSettings: const DateTimeInputUiSettings(
            labelText: 'Début',
            // labelFlex: 2,
            dateFormat: 'EEEE d MMMM y',
            initialDatePickerMode: DatePickerMode.year,
          ),
        ),
        DurationInput(
          id: 'duration',
          initialValue: event.duration,
          startDatePath: '/start',
          uiSettings: const DurationInputUiSettings(
            initialEditMode: DurationEditMode.dateTime,
            labelText: 'Durée',
            dateTimeLabelText: 'Fin',
            dateFormat: 'd MMMM',
          ),
        ),
      ],
      onSubmitting: (form, values) async {
        final start = values['/start'] as DateTime;
        final duration = values['/duration'] as Duration?;
        final edittedEvent = event.copyWith(
          title: values['/title'] as String,
          address: values['/address'] as String,
          start: values['/start'] as DateTime,
          finish: duration == null ? null : start.add(duration),
        );
        eventsCubit.update(event: edittedEvent);
      },
      onSubmitSuccess: (context) => Navigator.of(context).pop(),
    );
  }
}
