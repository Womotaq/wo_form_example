import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';

class MediasFormPage extends StatelessWidget {
  const MediasFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        titleText: 'Media examples',
      ),
      children: const [
        MediaInput(
          id: 'first',
          importSettings: MediaService.avatarImportSettings,
          maxCount: 1,
          aspectRatio: 1,
          // uiSettings: MediaInputUiSettings(

          // )
        ),
        MediaInput(
          id: 'second',
          importSettings: MediaService.imageImportSettings,
          maxCount: 1,
        ),
      ],
    );
  }
}
