import 'package:qapic/model/collections_model.dart';

String replacePlaceholders(String input, Environment environment) {
  // match between {{ }} to envParam key and replace with envParam value
  final RegExp pattern = RegExp(r'\{\{([^}]+)\}\}');

  final String updatedUrl = input.replaceAllMapped(
    pattern,
    (match) => environment.environmentParameters[match.group(1)] as String,
  );

  return updatedUrl;
}

String insertPlaceholder(String input, Environment environment) {
  if (environment.environmentParameters.isNotEmpty) {
    for (var env in environment.environmentParameters.entries) {
      RegExp pattern = RegExp(r'^\w{"' + env.value.toString() + r'"}$');
      input = input.replaceAllMapped(pattern, (match) => '{{${env.key}}}');
    }
  }
  return input;
}
