import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/quotes/presentation/pages/quotes_page.dart';
import '../../features/prices/presentation/pages/prices_page.dart';
import '../../features/tools/presentation/pages/tools_page.dart';
import '../../features/converters/presentation/pages/converters_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/settings/presentation/pages/privacy_policy_page.dart';
import '../../features/tools/presentation/pages/distance_calculator_page.dart';
import '../../features/games/presentation/pages/games_page.dart';
import '../../features/tools/presentation/pages/random_number_page.dart';
import '../../features/tools/presentation/pages/password_generator_page.dart';
import '../../features/tools/presentation/pages/plate_finder_page.dart';
import '../../features/tools/presentation/pages/vat_calculator_page.dart';
import '../../features/tools/presentation/pages/binary_converter_page.dart';
import '../../features/tools/presentation/pages/number_to_words_page.dart';
import '../../features/tools/presentation/pages/date_converter_page.dart';
import '../../features/tools/presentation/pages/base64_converter_page.dart';
import '../../features/tools/presentation/pages/stopwatch_page.dart';
import '../../features/tools/presentation/pages/ip_info_page.dart';
import '../../features/tools/presentation/pages/ocr_extractor_page.dart';
import '../../features/tools/presentation/pages/image_compressor_page.dart';
import '../../features/tools/presentation/pages/invoice_maker_page.dart';
import '../../features/tools/presentation/pages/qr_generator_page.dart';
import '../../features/tools/presentation/pages/currency_converter_page.dart';
import '../../features/tools/presentation/pages/unit_converter_page.dart';
import '../../features/tools/presentation/pages/color_converter_page.dart';
import '../../features/tools/presentation/pages/digital_signature_page.dart';
import '../../features/tools/presentation/pages/digit_converter_page.dart';
import '../../features/tools/presentation/pages/timestamp_converter_page.dart';
import '../../features/tools/presentation/pages/link_shortener_page.dart';
import '../../features/tools/presentation/pages/loan_calculator_page.dart';
import '../../features/tools/presentation/pages/deposit_calculator_page.dart';
import '../../features/tools/presentation/pages/savings_calculator_page.dart';
import '../../features/tools/presentation/pages/gold_calculator_page.dart';
import '../../features/tools/presentation/pages/gold_calculator_dashboard_page.dart';
import '../../features/tools/presentation/pages/whatsapp_link_generator_page.dart';
import '../../features/tools/presentation/pages/summarizer_page.dart';
import '../../features/tools/presentation/pages/events_page.dart';
import '../../features/tools/presentation/pages/remove_spaces_page.dart';
import '../../features/tools/presentation/pages/hearing_test_intro_page.dart';
import '../../features/tools/presentation/pages/hearing_test_page.dart';
import '../../features/tools/presentation/pages/social_post_generator_page.dart';
import '../../features/tools/presentation/pages/vision_test_intro_page.dart';
import '../../features/tools/presentation/pages/color_blindness_test_page.dart';
import '../../features/tools/presentation/pages/visual_acuity_test_page.dart';
import '../../features/tools/presentation/pages/bmi_calculator_page.dart';
import '../../features/tools/presentation/pages/age_calculator_page.dart';
import '../../features/tools/presentation/pages/legal_chatbot_page.dart';
import '../../features/tools/presentation/pages/iban_converter_page.dart';
import '../../features/tools/presentation/pages/qr_scanner_page.dart';
import '../../features/tools/presentation/pages/farsi_digit_converter_page.dart';
import '../../features/tools/presentation/pages/connect_four_page.dart';
import '../../features/tools/presentation/pages/memory_match_page.dart';
import '../../features/tools/presentation/pages/simon_says_page.dart';
import '../../features/tools/presentation/pages/othello_page.dart';
import '../../features/tools/presentation/pages/percent_calculator_page.dart';
import '../../features/tools/presentation/pages/timer_page.dart';
import '../../features/about/presentation/pages/feedback_page.dart';
import '../../features/tools/presentation/pages/whois_lookup_page.dart';
import '../../features/tools/presentation/pages/whois_results_page.dart';
import '../../features/tools/presentation/pages/raffle_page.dart';
import '../../features/tools/presentation/pages/reading_time_calculator_page.dart';
import '../../features/tools/presentation/pages/world_clock_page.dart';
import '../../features/tools/presentation/pages/gpa_calculator_page.dart';
import '../../features/tools/presentation/pages/national_id_validator_page.dart';
import '../../features/tools/presentation/pages/attorney_fee_calculator_page.dart';
import '../../features/tools/presentation/pages/power_root_calculator_page.dart';
import '../../features/tools/presentation/pages/text_analyzer_page.dart';
import '../../features/tools/presentation/pages/factorial_calculator_page.dart';
import '../../features/tools/presentation/pages/number_base_converter_page.dart';
import '../../features/tools/presentation/pages/bank_card_validator_page.dart';
import '../../features/tools/presentation/pages/alarm_page.dart';
import '../../features/tools/presentation/pages/gold_bubble_calculator_page.dart';
import '../../features/tools/presentation/pages/workout_timer_page.dart';

import '../../features/tools/presentation/pages/mahrieh_calculator_page.dart';
import '../../features/tools/presentation/pages/hafez_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String quotes = '/quotes';
  static const String prices = '/prices';
  static const String tools = '/tools';
  static const String converters = '/converters';
  static const String about = '/about';
  static const String settings = '/settings';

  static const String onboarding = '/onboarding';
  static const String support = '/support';
  static const String privacyPolicy = '/privacy_policy';
  static const String distanceCalculator = '/distance_calculator';
  static const String games = '/games';
  static const String randomNumber = '/random_number';
  static const String passwordGenerator = '/password_generator';
  static const String plateFinder = '/plate_finder';
  static const String vatCalculator = '/vat_calculator';
  static const String binaryConverter = '/binary_converter';
  static const String numberToWords = '/number_to_words';
  static const String dateConverter = '/date_converter';
  static const String base64Converter = '/base64_converter';
  static const String stopwatch = '/stopwatch';
  static const String ipInfo = '/ip_info';
  static const String ocrExtractor = '/ocr_extractor';
  static const String imageCompressor = '/image_compressor';
  static const String invoiceMaker = '/invoice_maker';
  static const String qrGenerator = '/qr_generator';
  static const String currencyConverter = '/currency_converter';
  static const String unitConverter = '/unit_converter';
  static const String colorConverter = '/color_converter';
  static const String digitalSignature = '/digital_signature';
  static const String digitConverter = '/digit_converter';
  static const String timestampConverter = '/timestamp_converter';
  static const String linkShortener = '/link_shortener';
  static const String loanCalculator = '/loan_calculator';
  static const String depositCalculator = '/deposit_calculator';
  static const String savingsCalculator = '/savings_calculator';
  static const String goldCalculator = '/gold_calculator';
  static const String goldDashboard = '/gold_dashboard';
  static const String whatsappLinkGenerator = '/whatsapp_link_generator';
  static const String summarizer = '/summarizer';
  static const String events = '/events';
  static const String removeSpaces = '/remove_spaces';
  static const String hearingTestIntro = '/hearing_test_intro';
  static const String hearingTest = '/hearing_test';
  static const String socialPostGenerator = '/social_post_generator';
  static const String visionTestIntro = '/vision_test_intro';
  static const String colorBlindnessTest = '/color_blindness_test';
  static const String visualAcuityTest = '/visual_acuity_test';
  static const String bmiCalculator = '/bmi_calculator';
  static const String ageCalculator = '/age_calculator';
  static const String legalChatbot = '/legal_chatbot';
  static const String ibanConverter = '/iban_converter';
  static const String qrScanner = '/qr_scanner';
  static const String farsiDigitConverter = '/farsi_digit_converter';
  static const String connectFour = '/connect_four';
  static const String memoryMatch = '/memory_match';
  static const String simonSays = '/simon_says';
  static const String othello = '/othello';
  static const String percentCalculator = '/percent_calculator';
  static const String timer = '/timer';
  static const String feedback = '/feedback';
  static const String whoisLookup = '/whois_lookup';
  static const String whoisResults = '/whois_results';
  static const String raffle = '/raffle';
  static const String readingTime = '/reading_time';
  static const String worldClock = '/world_clock';
  static const String gpaCalculator = '/gpa_calculator';
  static const String nationalIdValidator = '/national_id_validator';
  static const String attorneyFee = '/attorney_fee';
  static const String powerRootCalculator = '/power_root_calculator';
  static const String textAnalyzer = '/text_analyzer';
  static const String factorialCalculator = '/factorial_calculator';
  static const String numberBaseConverter = '/number_base_converter';
  static const String bankCardValidator = '/bank_card_validator';
  static const String alarm = '/alarm';
  static const String goldBubble = '/gold_bubble';
  static const String workoutTimer = '/workout_timer';
  static const String mahriehCalculator = '/mahrieh_calculator';
  static const String hafez = '/hafez';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashPage(),
      onboarding: (context) => const OnboardingPage(),
      home: (context) => const HomePage(),
      quotes: (context) => const QuotesPage(),
      prices: (context) => const PricesPage(),
      tools: (context) => const ToolsPage(),
      converters: (context) => const ConvertersPage(),
      about: (context) => const AboutPage(),
      settings: (context) => const SettingsPage(),
      support: (context) => const SupportPage(),
      privacyPolicy: (context) => const PrivacyPolicyPage(),
      distanceCalculator: (context) => const DistanceCalculatorPage(),
      games: (context) => const GamesPage(),
      randomNumber: (context) => const RandomNumberPage(),
      passwordGenerator: (context) => const PasswordGeneratorPage(),
      plateFinder: (context) => const PlateFinderPage(),
      vatCalculator: (context) => const VatCalculatorPage(),
      binaryConverter: (context) => const BinaryConverterPage(),
      numberToWords: (context) => const NumberToWordsPage(),
      dateConverter: (context) => const DateConverterPage(),
      base64Converter: (context) => const Base64ConverterPage(),
      stopwatch: (context) => const StopwatchPage(),
      ipInfo: (context) => const IpInfoPage(),
      ocrExtractor: (context) => const OcrExtractorPage(),
      imageCompressor: (context) => const ImageCompressorPage(),
      invoiceMaker: (context) => const InvoiceMakerPage(),
      qrGenerator: (context) => const QrGeneratorPage(),
      currencyConverter: (context) => const CurrencyConverterPage(),
      unitConverter: (context) => const UnitConverterPage(),
      colorConverter: (context) => const ColorConverterPage(),
      digitalSignature: (context) => const DigitalSignaturePage(),
      digitConverter: (context) => const DigitConverterPage(),
      timestampConverter: (context) => const TimestampConverterPage(),
      linkShortener: (context) => const LinkShortenerPage(),
      loanCalculator: (context) => const LoanCalculatorPage(),
      depositCalculator: (context) => const DepositCalculatorPage(),
      savingsCalculator: (context) => const SavingsCalculatorPage(),
      goldCalculator: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
        return GoldCalculatorPage(initialIndex: args);
      },
      goldDashboard: (context) => const GoldCalculatorDashboardPage(),
      whatsappLinkGenerator: (context) => const WhatsAppLinkGeneratorPage(),
      summarizer: (context) => const SummarizerPage(),
      events: (context) => const EventsPage(),
      removeSpaces: (context) => const RemoveSpacesPage(),
      hearingTestIntro: (context) => const HearingTestIntroPage(),
      hearingTest: (context) => const HearingTestPage(),
      socialPostGenerator: (context) => const SocialPostGeneratorPage(),
      visionTestIntro: (context) => const VisionTestIntroPage(),
      colorBlindnessTest: (context) => const ColorBlindnessTestPage(),
      visualAcuityTest: (context) => const VisualAcuityTestPage(),
      bmiCalculator: (context) => const BmiCalculatorPage(),
      ageCalculator: (context) => const AgeCalculatorPage(),
      legalChatbot: (context) => const LegalChatbotPage(),
      ibanConverter: (context) => const IbanConverterPage(),
      qrScanner: (context) => const QrScannerPage(),
      farsiDigitConverter: (context) => const FarsiDigitConverterPage(),
      connectFour: (context) => const ConnectFourPage(),
      memoryMatch: (context) => const MemoryMatchPage(),
      simonSays: (context) => const SimonSaysPage(),
      othello: (context) => const OthelloPage(),
      percentCalculator: (context) => const PercentCalculatorPage(),
      timer: (context) => const TimerPage(),
      feedback: (context) => const FeedbackPage(),
      whoisLookup: (context) => const WhoisLookupPage(),
      whoisResults: (context) {
        final domain = ModalRoute.of(context)!.settings.arguments as String;
        return WhoisResultsPage(domain: domain);
      },
      raffle: (context) => const RafflePage(),
      readingTime: (context) => const ReadingTimeCalculatorPage(),
      worldClock: (context) => const WorldClockPage(),
      gpaCalculator: (context) => const GpaCalculatorPage(),
      nationalIdValidator: (context) => const NationalIdValidatorPage(),
      attorneyFee: (context) => const AttorneyFeeCalculatorPage(),
      bankCardValidator: (context) => const BankCardValidatorPage(),
      powerRootCalculator: (context) => const PowerRootCalculatorPage(),
      textAnalyzer: (context) => const TextAnalyzerPage(),
      factorialCalculator: (context) => const FactorialCalculatorPage(),
      numberBaseConverter: (context) => const NumberBaseConverterPage(),
      alarm: (context) => const AlarmPage(),
      goldBubble: (context) => const GoldBubbleCalculatorPage(),
      workoutTimer: (context) => const WorkoutTimerPage(),
      mahriehCalculator: (context) => const MahriehCalculatorPage(),
      hafez: (context) => const HafezPage(),
    };
  }
}
