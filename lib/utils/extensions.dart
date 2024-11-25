import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<T?> pushPage<T extends Object?>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute<T>(builder: (_) => page),
      );
}
