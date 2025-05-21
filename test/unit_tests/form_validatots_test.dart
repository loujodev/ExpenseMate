import 'package:expense_mate/src/shared/utils/form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormValidators.validateEmail', () {
    test('should return error message when email is null', () {
      expect(FormValidators.validateEmail(null), 'Please enter an email');
    });
    test('should return error message when email is empty', () {
      expect(FormValidators.validateEmail(''), 'Please enter an email');
    });
    test('should return error message for invalid email formats', () {
      expect(FormValidators.validateEmail('abc'), 'Please enter a valid mail');
      expect(FormValidators.validateEmail('abc@'), 'Please enter a valid mail');
      expect(
        FormValidators.validateEmail('abc@def'),
        'Please enter a valid mail',
      );
      expect(
        FormValidators.validateEmail('abc@def.'),
        'Please enter a valid mail',
      );
    });
    test('should return null for a valid email', () {
      expect(FormValidators.validateEmail('test@example.com'), null);
    });
  });

  group('FormValidators.validatePassword', () {
    test('should return error message when password is null', () {
      expect(FormValidators.validatePassword(null), 'Please enter a password');
    });
    test('should return error message when password is empty', () {
      expect(FormValidators.validatePassword(''), 'Please enter a password');
    });
    test('should return error message when password is too short', () {
      expect(
        FormValidators.validatePassword('12345'),
        'Password needs to contain at least 6 symbols',
      );
    });
    test('should return null for a valid password', () {
      expect(FormValidators.validatePassword('123456'), null);
      expect(FormValidators.validatePassword('abcdefg'), null);
    });
  });

  group('FormValidators.validatePasswordConfirmation', () {
    test('should return error message when confirmation is null', () {
      expect(
        FormValidators.validatePasswordConfirmation(null, 'abc'),
        'Please confirm password',
      );
    });
    test('should return error message when confirmation is empty', () {
      expect(
        FormValidators.validatePasswordConfirmation('', 'abc'),
        'Please confirm password',
      );
    });
    test('should return error message when passwords do not match', () {
      expect(
        FormValidators.validatePasswordConfirmation('123', 'abc'),
        'Passwords do not match',
      );
    });
    test('should return null when passwords match', () {
      expect(FormValidators.validatePasswordConfirmation('abc', 'abc'), null);
    });
  });

  group('FormValidators.validateName', () {
    test('should return error message when name is null', () {
      expect(FormValidators.validateName(null), 'Please enter a name');
    });
    test('should return error message when name is empty', () {
      expect(FormValidators.validateName(''), 'Please enter a name');
    });
    test('should return error message when name is too short', () {
      expect(
        FormValidators.validateName('A'),
        'Your name must contain at least two characters',
      );
    });
    test('should return null for a valid name', () {
      expect(FormValidators.validateName('Max'), null);
      expect(FormValidators.validateName('Alice'), null);
    });
  });

  group('FormValidators.validateNotEmpty', () {
    test('should return error message when value is null', () {
      expect(
        FormValidators.validateNotEmpty(null, 'Field'),
        'Please enter Field',
      );
    });
    test('should return error message when value is empty', () {
      expect(
        FormValidators.validateNotEmpty('', 'Field'),
        'Please enter Field',
      );
    });
    test('should return null when value is not empty', () {
      expect(FormValidators.validateNotEmpty('SomeValue', 'Field'), null);
    });
  });
}
