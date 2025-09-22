import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';

class ContainerNode extends WidgetNode {
  ContainerNode({
    Color? color,
    String? text,
    int? flex,
  }) : super(
          uiSettings: InputUiSettings(flex: flex),
          builder: (context) => ColoredBox(
            color: color ?? Colors.redAccent,
            child: Center(
              child: Text(text ?? 'ContainerNode'),
            ),
          ),
        );
}
