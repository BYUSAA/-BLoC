import '../../app/constants/app_constants.dart';

abstract final class Validators {
  static final RegExp _emailPattern =
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'Use at least 6 characters.';
    return null;
  }

  static String? recordTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.isEmpty) return 'Title is required.';
    if (title.length > AppConstants.maxRecordTitleLength) {
      return 'Title cannot exceed '
          '${AppConstants.maxRecordTitleLength} characters.';
    }
    return null;
  }

  static String? recordDescription(String? value) {
    if ((value?.length ?? 0) > AppConstants.maxRecordDescriptionLength) {
      return 'Description cannot exceed '
          '${AppConstants.maxRecordDescriptionLength} characters.';
    }
    return null;
  }
}
