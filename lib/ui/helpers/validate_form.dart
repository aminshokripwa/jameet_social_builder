import 'package:form_field_validator/form_field_validator.dart';
import 'package:jameet_social_builder/localization_helper.dart';

final validatedEmail = MultiValidator([
  RequiredValidator(errorText: LanguageJameet.email_is_required),
  EmailValidator(errorText: LanguageJameet.enter_valid_email)
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: LanguageJameet.password_is_required),
  MinLengthValidator(8, errorText: LanguageJameet.minmum_8_charecters)
]);