// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Account Book';

  @override
  String get refresh => 'Refresh';

  @override
  String get settings => 'Settings';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get transactions => 'Transactions';

  @override
  String get summary => 'Summary';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get balance => 'Balance';

  @override
  String get category => 'Category';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description (Optional)';

  @override
  String get date => 'Date';

  @override
  String dateFormat(int year, int month, int day) {
    return '$month/$day/$year';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get addIncome => 'Add Income';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get editIncome => 'Edit Income';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get deleteConfirmTitle => 'Delete Transaction';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this transaction?';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionSaved => 'Transaction saved';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get errorSaving => 'Error occurred while saving';

  @override
  String get pleaseEnterAmount => 'Please enter amount';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid integer';

  @override
  String get noTransactionsToday => 'No transactions today';

  @override
  String get noTransactionsThisMonth => 'No transactions this month';

  @override
  String get loginRequired => 'Login required';

  @override
  String get retry => 'Retry';

  @override
  String get weeklySummary => 'Weekly Summary';

  @override
  String get language => 'Language';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categorySideJob => 'Side Job';

  @override
  String get categoryInvestment => 'Investment';

  @override
  String get categoryOtherIncome => 'Other Income';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryCulture => 'Culture';

  @override
  String get categoryMedical => 'Medical';

  @override
  String get categoryOtherExpense => 'Other Expense';

  @override
  String get type => 'Type';

  @override
  String get validationAmount => 'Please enter amount';

  @override
  String get validationInteger => 'Please enter a valid integer';

  @override
  String get errorTransactionIdNotFound => 'Transaction ID not found';

  @override
  String get successTransactionUpdated => 'Transaction updated';

  @override
  String get successTransactionSaved => 'Transaction saved';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String deleteTransactionConfirm(String category) {
    return 'Are you sure you want to delete $category transaction?';
  }

  @override
  String get successTransactionDeleted => 'Transaction deleted';

  @override
  String get errorDeleting => 'Error occurred while deleting';

  @override
  String get calendarMonthly => 'Monthly';

  @override
  String get calendarWeekly => 'Weekly';

  @override
  String get sunday => 'Sun';

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get weeklyTotal => 'Weekly Total';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get currencyWon => '';

  @override
  String get currencyThousand => 'K';

  @override
  String get currencyTenThousand => 'K';

  @override
  String get currencyUnit => 'Currency Unit';

  @override
  String get currencyKRW => 'Korean Won (₩)';

  @override
  String get currencyUSD => 'US Dollar (\$)';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get linkAccount => 'Link Account';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get enterEmail => 'Enter your email address';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterName => 'Enter your name';

  @override
  String get validationEmail => 'Please enter a valid email address';

  @override
  String get validationPassword => 'Password must be at least 6 characters';

  @override
  String get validationName => 'Please enter your name';

  @override
  String get validationEmpty => 'The input is empty';

  @override
  String get successfullyLoggedIn => 'Successfully logged in!';

  @override
  String get currentUserUID => 'Current User UID';

  @override
  String get anonymousUser => 'Anonymous User';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get featureComingSoon => 'Feature coming soon!';

  @override
  String get linkAccountDescription =>
      'Link your anonymous account with email and password';

  @override
  String get accountLinkedSuccess => 'Account linked successfully!';

  @override
  String get errorOccurredAuth => 'An error occurred';

  @override
  String get errorUserNotFound => 'No user found for that email';

  @override
  String get errorWrongPassword => 'Wrong password provided';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorWeakPassword => 'The password provided is too weak';

  @override
  String get errorEmailInUse => 'The account already exists for that email';

  @override
  String get errorProviderLinked =>
      'The provider has already been linked to the user';

  @override
  String get errorInvalidCredential =>
      'The provider\'s credential is not valid';

  @override
  String get errorCredentialInUse =>
      'This credential is already associated with a different user account';

  @override
  String get noUserLoggedIn => 'No user logged in';
}
