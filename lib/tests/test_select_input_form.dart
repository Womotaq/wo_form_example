import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/capitalized.dart';
import 'package:wo_form_example/utils/presentation_cubit.dart';

class TestSelectInputForm extends WoForm {
  TestSelectInputForm(BuildContext context, {super.key})
      : super(
          uiSettings: WoFormUiSettings(
            presentation: context.read<PresentationCubit>().state,
            submitButtonPosition: SubmitButtonPosition.appBar,
          ),
          children: [
            SelectInput<ChildrenVisibility>(
              id: 'childrenVisibility',
              minCount: 1,
              maxCount: 1,
              initialValues: [ChildrenVisibility.whenAsked],
              availibleValues: ChildrenVisibility.values,
              uiSettings: SelectInputUiSettings(
                headerFlex: 11,
                labelText: 'See the options :',
                childrenVisibility: ChildrenVisibility.whenAsked,
                flex: 0,
                valueBuilder: (value) => value == null
                    ? const Text('Select a value')
                    : Text(value.name.capitalized()),
              ),
            ),
            ValueBuilderNode(
              id: 'builder',
              path: '#childrenVisibility',
              builder: (value) {
                final childrenVisibility =
                    (value as List<ChildrenVisibility>? ?? []).firstOrNull ??
                        ChildrenVisibility.whenAsked;

                return SelectInput<City>(
                  id: 'select',
                  maxCount: 1,
                  availibleValues: City.values,
                  uiSettings: SelectInputUiSettings(
                    headerFlex: 11,
                    labelText: 'Ville',
                    childrenVisibility: childrenVisibility,
                    valueBuilder: (value) => value == null
                        ? const Text('Select a value')
                        : Text(value.name.capitalized()),
                  ),
                );
              },
            ),
            ValueBuilderNode(
              id: 'builder3',
              path: '#childrenVisibility',
              builder: (value) {
                final childrenVisibility =
                    (value as List<ChildrenVisibility>? ?? []).firstOrNull ??
                        ChildrenVisibility.whenAsked;

                return InputsNode(
                  id: 'list',
                  children: [
                    SelectInput<City>(
                      id: 'searchDefault',
                      maxCount: 1,
                      availibleValues: City.values,
                      uiSettings: SelectInputUiSettings(
                        flex: 1,
                        headerFlex: 11,
                        labelText: 'Ville',
                        helperText: 'default search',
                        childrenVisibility: childrenVisibility,
                        searchScore: (query, value) =>
                            query.searchScore(value.name),
                        valueBuilder: (value) => value == null
                            ? const Text('Select a value')
                            : Text(value.name.capitalized()),
                      ),
                    ),
                    SelectInput<City>(
                      id: 'searchPage',
                      maxCount: 1,
                      availibleValues: City.values,
                      uiSettings: SelectInputUiSettings(
                        flex: 1,
                        headerFlex: 11,
                        labelText: 'Ville',
                        helperText: 'page search',
                        childrenVisibility: childrenVisibility,
                        searchScore: (query, value) =>
                            query.searchScore(value.name),
                        valueBuilder: (value) => value == null
                            ? const Text('Select a value')
                            : Text(value.name.capitalized()),
                        openChildren: Push.screen,
                      ),
                    ),
                    SelectInput<City>(
                      id: 'searchMenu',
                      maxCount: 1,
                      availibleValues: City.values,
                      uiSettings: SelectInputUiSettings(
                        flex: 1,
                        headerFlex: 11,
                        labelText: 'Ville',
                        helperText: 'menu search',
                        childrenVisibility: childrenVisibility,
                        searchScore: (query, value) =>
                            query.searchScore(value.name),
                        valueBuilder: (value) => value == null
                            ? const Text('Select a value')
                            : Text(value.name.capitalized()),
                        openChildren: Push.menu,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
}

enum City {
  amsterdam,
  berlin,
  delhi,
  karachi,
  istambul,
  mexico,
  moscou,
  paris,
  pekin,
  shanghai,
  tokyo,
}
