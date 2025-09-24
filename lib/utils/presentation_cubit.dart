import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wo_form/wo_form.dart';

export 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

class PresentationCubit extends Cubit<WoFormPresentation> {
  PresentationCubit() : super(WoFormPresentation.page);

  void toggle() => emit(
        state == WoFormPresentation.page
            ? WoFormPresentation.bottomSheet
            : WoFormPresentation.page,
      );
}

extension BuildContextExt on BuildContext {
  Future<void> openForm(WoForm form) =>
      switch (form.root.uiSettings.presentation) {
        WoFormPresentation.page => pushPage(form),
        WoFormPresentation.dialog ||
        WoFormPresentation.bottomSheet =>
          _showWoFormModal(context: this, form: form)
      };

  Future<T?> pushPage<T extends Object?>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute<T>(builder: (_) => page),
      );
}

enum ModalSize {
  /// The modal does the same size as its child.
  fitContent,

  /// The child is wrapped inside a SingleChildScrollView.
  /// The modal starts at .7% of the screen height.
  flexible,
}

Future<T?> _showWoFormModal<T extends Object?>({
  required BuildContext context,
  required WoForm form,
}) {
  final acceptScrollController = form.root.uiSettings.acceptScrollController;
  final size =
      acceptScrollController ? ModalSize.flexible : ModalSize.fitContent;
  final isDialog =
      form.root.uiSettings.presentation == WoFormPresentation.dialog;

  Widget buildForm(BuildContext context) {
    final double? height;
    if (acceptScrollController) {
      height = null;
    } else {
      final mediaQuery = MediaQuery.of(context);
      height = (mediaQuery.size.height - mediaQuery.viewInsets.bottom) * .7;
    }

    return SizedBox(
      height: height,
      child: form,
    );
  }

  Widget buildContent(BuildContext context) => isDialog
      ? buildForm(context)
      : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: size == ModalSize.fitContent ? 0 : 1,
              child: Stack(
                children: [
                  buildForm(context),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        width: 48,
                        height: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

  if (isDialog) {
    return showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        children: [
          SizedBox(
            width: 512,
            child: buildContent(dialogContext),
          ),
        ],
      ),
    );
  } else {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      clipBehavior: Clip.hardEdge,
      builder: (context) => Padding(
        // This padding allows the modal to adjust to the keyboard
        // See : https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: switch (size) {
          ModalSize.fitContent => buildContent(context),
          ModalSize.flexible => DraggableScrollableSheet(
              expand: false,
              initialChildSize: .7,
              minChildSize: .5,
              builder: (context, scrollController) => ScrollControllerProvider(
                controller: scrollController,
                child: buildContent(context),
              ),
            ),
        },
      ),
    );
  }
}
