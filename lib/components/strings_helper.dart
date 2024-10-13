class StringsHelper {
  String formatValue(int value) {
    if (value < 1000) {
      return value.toString();
    } else {
      double formattedValue = value / 1000.0;
      return '${formattedValue.toStringAsFixed(1)}K';
    }
  }
}

extension SentenceCase on String {
  String toSentenceCase() {
    if (isEmpty) {
      return '';
    }

    final sentences = split(RegExp(r'(?<=[.!?])\s+'));

    final sentenceCaseText = sentences
        .map((sentence) =>
            sentence.trimLeft().substring(0, 1).toUpperCase() +
            sentence.trimLeft().substring(1).toLowerCase())
        .join(' ');

    return sentenceCaseText[0].toUpperCase() + sentenceCaseText.substring(1);
  }
}

String sanitizeNumber(String phoneNumber) {
  // Remove leading zeros
  return phoneNumber.replaceFirst(RegExp(r'^0+'), '');
}

String combineDialCodeWithNumber(String dialCode, String phoneNumber) {
  // Remove leading zeros
  String sanitizedNumber = phoneNumber.replaceFirst(RegExp(r'^0+'), '');
  // Combine dial code with sanitized phone number
  return '$dialCode$sanitizedNumber';
}

extension DoubleFormatting on double {
  String toCommaSeparated() {
    // Convert the double to a string with 2 decimal places
    return toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},');
  }
}
