import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';

class MediasFormPage extends StatelessWidget {
  const MediasFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        titleText: 'Media examples',
        theme: WoFormThemeData(spacing: 16),
      ),
      children: [
        WidgetNode(
          builder: (context) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Profil picture :\n- Circle (ratio 1)\n- 512 x 512 max'
              '\n- Option to take selfie\n- Grid',
            ),
          ),
        ),
        const MediaInput(
          id: 'profile',
          importSettings: MediaService.avatarImportSettings,
          maxCount: 1,
          uiSettings: MediaInputUiSettings(
            cropShowGrid: true,
            cropAspectRatioOrCircle: MediaService.circleAspectRatio,
          ),
        ),
        WidgetNode(
          builder: (context) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Banner photo :\n- Ratio 3\n- 1536 x 512 max'
              '\n- Option to take photo',
            ),
          ),
        ),
        const MediaInput(
          id: 'banner',
          importSettings: MediaService.imageImportSettings,
          maxCount: 1,
          uiSettings: MediaInputUiSettings(
            cropAspectRatioOrCircle: 3,
          ),
        ),
        WidgetNode(
          builder: (context) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Multiple photos :\n- Free ratio\n- no compression'
              '\n- Option to take photo',
            ),
          ),
        ),
        const MediaInput(
          id: 'free',
          importSettings: MediaImportSettings(
            type: MediaType.image,
            methods: [
              MediaImportMethodPickMedias(source: ImageSource.gallery),
              MediaImportMethodPickMedias(source: ImageSource.camera),
            ],
          ),
          maxCount: null,
        ),
      ],
    );
  }
}
