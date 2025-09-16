import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/edit_event/event.dart';
import 'package:wo_form_example/edit_event/event_page.dart';
import 'package:wo_form_example/utils/discard_changes_dialog.dart';

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
      uiSettings: const WoFormUiSettings(
        submitMode: StandardSubmitMode(
          submitText: 'Save',
          disableSubmitMode: DisableSubmitButton.whenInitialOrSubmitSuccess,
          buttonPosition: SubmitButtonPosition.appBar,
        ),
        canQuit: showDiscardChangesDialogIfWoFormUnsaved,
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
          initialValue: event.address?.name,
          placeAutocompleteSettings: const PlaceAutocompleteSettings(
            type: PlaceType.address,
            countries: [IsoCode.FR],
            // includeDetails: false,
          ),
          uiSettings: const StringInputUiSettings(
            labelText: 'Address',
            action: StringFieldAction.clear,
          ),
        ),
        WidgetNode(builder: (_) => const SizedBox(height: 32)),
        DateTimeInput(
          id: 'start',
          isRequired: true,
          initialValue: FixedDateTime(date: event.start),
          uiSettings: const DateTimeInputUiSettings(
            dateFormat: 'E, MMM d, y',
            prefixIcon: Icon(Icons.calendar_month),
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
            dateFormat: 'E, MMM d, y',
            prefixIcon: Icon(Icons.calendar_month),
          ),
        ),
      ],
      onSubmitting: (form, values) async {
        final addressName = values['/address'] as String?;
        final AddressModel? address;
        if (addressName == event.address?.name) {
          address = event.address;
        } else if (addressName == null) {
          address = null;
        } else {
          final details = values['/address+details'] as PlaceDetails?;
          final latitude = details?.latitude;
          final longitude = details?.longitude;
          if (latitude == null || longitude == null) {
            throw Exception('The coordinates of the address are unknown');
          }
          address = AddressModel(
            name: addressName,
            latitude: latitude,
            longitude: longitude,
          );
          print(address);
        }

        final edittedEvent = event.copyWith(
          title: values['/title'] as String,
          address: address,
          start: values['/start'] as DateTime,
          finish: values['/finish'] as DateTime,
        );
        eventsCubit.update(event: edittedEvent);
      },
      // onSubmitSuccess: showJsonDialog,
      onSubmitSuccess: (context) => Navigator.of(context).pop(),
    );
  }
}
