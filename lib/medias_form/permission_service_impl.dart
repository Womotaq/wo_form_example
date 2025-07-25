import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/app.dart';

class PermissionServiceImpl extends PermissionService {
  const PermissionServiceImpl();

  @override
  Future<bool> requirePhotos() async {
    switch (await Permission.photos.request()) {
      case PermissionStatus.denied: // The user just denied the permission
      case PermissionStatus.restricted: // The OS denies the permission
        return false;
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
      case PermissionStatus.permanentlyDenied:
        // The user already denied the permission
        showInsufficientPermissionSnackBar(
          title: "Veuillez acccorder l'accès à vos photos.",
        );
        return false;
    }
  }

  @override
  Future<bool> requireCamera() async {
    switch (await Permission.camera.request()) {
      case PermissionStatus.denied: // The user just denied the permission
      case PermissionStatus.restricted: // The OS denies the permission
        return false;
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
      case PermissionStatus.permanentlyDenied:
        // The user already denied the permission
        showInsufficientPermissionSnackBar(
          title: "Veuillez acccorder l'accès à votre appareil photo.",
        );
        return false;
    }
  }

  void showInsufficientPermissionSnackBar({required String title}) =>
      ScaffoldMessenger.of(App.context)
          .showSnackBar(SnackBar(content: Text(title)));
}
