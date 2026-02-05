import 'package:flutter_test/flutter_test.dart';
import 'package:tabdila/core/utils/digit_utils.dart';
import 'dart:math' as math;

void main() {
  group('DigitUtils Tests', () {
    test('toFarsi converts English digits to Persian', () {
      expect(DigitUtils.toFarsi('123'), '۱۲۳');
      expect(DigitUtils.toFarsi('0'), '۰');
      expect(DigitUtils.toFarsi('9876543210'), '۹۸۷۶۵۴۳۲۱۰');
    });

    test('toEnglish converts Persian digits to English', () {
      expect(DigitUtils.toEnglish('۱۲۳'), '123');
      expect(DigitUtils.toEnglish('۰'), '0');
      expect(DigitUtils.toEnglish('۹۸۷۶۵۴۳۲۱۰'), '9876543210');
    });

    test('parseDouble handles both Persian and English digits', () {
      expect(DigitUtils.parseDouble('123'), 123.0);
      expect(DigitUtils.parseDouble('۱۲۳'), 123.0);
      expect(DigitUtils.parseDouble('12.5'), 12.5);
      expect(DigitUtils.parseDouble('۱۲.۵'), 12.5);
    });
  });

  group('Mathematical Calculations', () {
    test('Factorial calculation', () {
      BigInt factorial(int n) {
        if (n <= 1) return BigInt.one;
        BigInt result = BigInt.one;
        for (int i = 2; i <= n; i++) {
          result *= BigInt.from(i);
        }
        return result;
      }

      expect(factorial(0), BigInt.one);
      expect(factorial(1), BigInt.one);
      expect(factorial(5), BigInt.from(120));
      expect(factorial(10), BigInt.from(3628800));
    });

    test('Power and Root calculations', () {
      expect(math.pow(2, 3), 8);
      expect(math.pow(5, 2), 25);
      expect(math.sqrt(144), 12);
      expect(math.pow(27, 1 / 3).toStringAsFixed(1), '3.0');
    });

    test('BMI calculation', () {
      double calculateBMI(double weight, double height) {
        return weight / math.pow(height / 100, 2);
      }

      expect(calculateBMI(70, 175).toStringAsFixed(1), '22.9');
      expect(calculateBMI(80, 180).toStringAsFixed(1), '24.7');
    });

    test('Percentage calculations', () {
      double calculatePercentage(double value, double total) {
        return (value / total) * 100;
      }

      expect(calculatePercentage(25, 100), 25.0);
      expect(calculatePercentage(50, 200), 25.0);
      expect(calculatePercentage(75, 150).toStringAsFixed(1), '50.0');
    });
  });

  group('Validation Tests', () {
    test('National ID validation', () {
      bool validateNationalId(String code) {
        if (code.length != 10) return false;

        final digits = code.split('').map((e) => int.parse(e)).toList();
        int sum = 0;

        for (int i = 0; i < 9; i++) {
          sum += digits[i] * (10 - i);
        }

        int remainder = sum % 11;
        int checkDigit = remainder < 2 ? remainder : 11 - remainder;

        return checkDigit == digits[9];
      }

      expect(validateNationalId('0012345678'), true);
      expect(validateNationalId('1234567890'), false);
      expect(validateNationalId('123'), false);
    });

    test('Bank card validation (Luhn algorithm)', () {
      bool validateCardNumber(String cardNumber) {
        if (cardNumber.length != 16) return false;

        int sum = 0;
        bool alternate = false;

        for (int i = cardNumber.length - 1; i >= 0; i--) {
          int digit = int.parse(cardNumber[i]);

          if (alternate) {
            digit *= 2;
            if (digit > 9) digit -= 9;
          }

          sum += digit;
          alternate = !alternate;
        }

        return sum % 10 == 0;
      }

      expect(validateCardNumber('6037997000000000'), true);
      expect(validateCardNumber('1234567890123456'), false);
    });
  });

  group('Conversion Tests', () {
    test('Base conversion', () {
      expect(int.parse('FF', radix: 16), 255);
      expect(int.parse('1010', radix: 2), 10);
      expect(255.toRadixString(16).toUpperCase(), 'FF');
      expect(10.toRadixString(2), '1010');
    });

    test('Temperature conversion', () {
      double celsiusToFahrenheit(double celsius) {
        return (celsius * 9 / 5) + 32;
      }

      double fahrenheitToCelsius(double fahrenheit) {
        return (fahrenheit - 32) * 5 / 9;
      }

      expect(celsiusToFahrenheit(0), 32);
      expect(celsiusToFahrenheit(100), 212);
      expect(fahrenheitToCelsius(32), 0);
      expect(fahrenheitToCelsius(212), 100);
    });

    test('Length conversion', () {
      double meterToFeet(double meter) {
        return meter * 3.28084;
      }

      double feetToMeter(double feet) {
        return feet / 3.28084;
      }

      expect(meterToFeet(1).toStringAsFixed(2), '3.28');
      expect(feetToMeter(3.28084).toStringAsFixed(2), '1.00');
    });
  });

  group('Financial Calculations', () {
    test('VAT calculation', () {
      double calculateVAT(double amount, double rate) {
        return amount * (rate / 100);
      }

      expect(calculateVAT(1000, 10), 100);
      expect(calculateVAT(5000, 9), 450);
    });

    test('Loan installment calculation', () {
      double calculateInstallment(double principal, double rate, int months) {
        double monthlyRate = rate / 100 / 12;
        return principal *
            (monthlyRate * math.pow(1 + monthlyRate, months)) /
            (math.pow(1 + monthlyRate, months) - 1);
      }

      // Test with 10 million principal, 18% annual rate, 12 months
      double installment = calculateInstallment(10000000, 18, 12);
      expect(installment > 900000, true);
      expect(installment < 950000, true);
    });

    test('Savings calculation', () {
      double calculateSavings(double monthly, double rate, int months) {
        double monthlyRate = rate / 100 / 12;
        return monthly *
            ((math.pow(1 + monthlyRate, months) - 1) / monthlyRate);
      }

      double savings = calculateSavings(1000000, 20, 12);
      expect(savings > 12000000, true);
      expect(savings < 15000000, true);
    });
  });

  group('Date and Time Tests', () {
    test('Age calculation', () {
      int calculateAge(DateTime birthDate) {
        DateTime today = DateTime.now();
        int age = today.year - birthDate.year;

        if (today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }

        return age;
      }

      DateTime birthDate = DateTime(2000, 1, 1);
      int age = calculateAge(birthDate);
      expect(age >= 24, true);
      expect(age <= 26, true);
    });

    test('Timestamp conversion', () {
      DateTime date = DateTime(2024, 1, 1);
      int timestamp = date.millisecondsSinceEpoch ~/ 1000;
      DateTime converted =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

      expect(converted.year, 2024);
      expect(converted.month, 1);
      expect(converted.day, 1);
    });
  });

  group('Text Processing Tests', () {
    test('Remove spaces', () {
      String removeSpaces(String text) {
        return text.replaceAll(RegExp(r'\s+'), '');
      }

      expect(removeSpaces('Hello World'), 'HelloWorld');
      expect(removeSpaces('  Test  '), 'Test');
      expect(removeSpaces('A B C D'), 'ABCD');
    });

    test('Word count', () {
      int countWords(String text) {
        return text.trim().split(RegExp(r'\s+')).length;
      }

      expect(countWords('Hello World'), 2);
      expect(countWords('One Two Three Four'), 4);
      expect(countWords('  Spaces  everywhere  '), 2);
    });

    test('Character count', () {
      int countChars(String text, {bool includeSpaces = true}) {
        if (includeSpaces) return text.length;
        return text.replaceAll(RegExp(r'\s+'), '').length;
      }

      expect(countChars('Hello'), 5);
      expect(countChars('Hello World'), 11);
      expect(countChars('Hello World', includeSpaces: false), 10);
    });
  });

  group('Random Generation Tests', () {
    test('Random number generation', () {
      int generateRandom(int min, int max) {
        return min + math.Random().nextInt(max - min + 1);
      }

      for (int i = 0; i < 100; i++) {
        int random = generateRandom(1, 100);
        expect(random >= 1, true);
        expect(random <= 100, true);
      }
    });

    test('Password generation', () {
      String generatePassword(int length) {
        const chars =
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
        return List.generate(
                length, (index) => chars[math.Random().nextInt(chars.length)])
            .join();
      }

      String password = generatePassword(12);
      expect(password.length, 12);

      password = generatePassword(20);
      expect(password.length, 20);
    });
  });
}
