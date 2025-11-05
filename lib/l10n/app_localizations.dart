import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 앱 제목
  ///
  /// In ko, this message translates to:
  /// **'가계부'**
  String get appTitle;

  /// 새로고침 버튼
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get refresh;

  /// 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// 계정 정보 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 정보'**
  String get accountInfo;

  /// 거래내역 탭
  ///
  /// In ko, this message translates to:
  /// **'거래내역'**
  String get transactions;

  /// 요약 탭
  ///
  /// In ko, this message translates to:
  /// **'요약'**
  String get summary;

  /// 거래 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'거래 추가'**
  String get addTransaction;

  /// 수입
  ///
  /// In ko, this message translates to:
  /// **'수입'**
  String get income;

  /// 지출
  ///
  /// In ko, this message translates to:
  /// **'지출'**
  String get expense;

  /// 잔액
  ///
  /// In ko, this message translates to:
  /// **'잔액'**
  String get balance;

  /// 카테고리
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get category;

  /// 금액
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get amount;

  /// 설명 입력 필드
  ///
  /// In ko, this message translates to:
  /// **'설명 (선택사항)'**
  String get description;

  /// 날짜
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get date;

  /// 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// 수정 버튼
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get edit;

  /// 닫기 버튼
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// 수입 추가
  ///
  /// In ko, this message translates to:
  /// **'수입 추가'**
  String get addIncome;

  /// 지출 추가
  ///
  /// In ko, this message translates to:
  /// **'지출 추가'**
  String get addExpense;

  /// 수입 수정
  ///
  /// In ko, this message translates to:
  /// **'수입 수정'**
  String get editIncome;

  /// 지출 수정
  ///
  /// In ko, this message translates to:
  /// **'지출 수정'**
  String get editExpense;

  /// 삭제 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'거래 삭제'**
  String get deleteConfirmTitle;

  /// 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 거래 내역을 삭제하시겠습니까?'**
  String get deleteConfirmMessage;

  /// 삭제 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 삭제되었습니다'**
  String get transactionDeleted;

  /// 저장 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 저장되었습니다'**
  String get transactionSaved;

  /// 수정 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 수정되었습니다'**
  String get transactionUpdated;

  /// 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get errorOccurred;

  /// 저장 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장 중 오류가 발생했습니다'**
  String get errorSaving;

  /// 금액 입력 요청
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력하세요'**
  String get pleaseEnterAmount;

  /// 유효한 숫자 입력 요청
  ///
  /// In ko, this message translates to:
  /// **'올바른 정수를 입력하세요'**
  String get pleaseEnterValidNumber;

  /// 오늘 거래 없음
  ///
  /// In ko, this message translates to:
  /// **'오늘 거래 내역이 없습니다'**
  String get noTransactionsToday;

  /// 이번 달 거래 없음
  ///
  /// In ko, this message translates to:
  /// **'이번 달 거래 내역이 없습니다'**
  String get noTransactionsThisMonth;

  /// 로그인 필요 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다'**
  String get loginRequired;

  /// 다시 시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// 주간 합계
  ///
  /// In ko, this message translates to:
  /// **'주간 합계'**
  String get weeklySummary;

  /// 언어 설정
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// 한국어
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// 영어
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// 카테고리: 급여
  ///
  /// In ko, this message translates to:
  /// **'급여'**
  String get categorySalary;

  /// 카테고리: 부업
  ///
  /// In ko, this message translates to:
  /// **'부업'**
  String get categorySideJob;

  /// 카테고리: 투자수익
  ///
  /// In ko, this message translates to:
  /// **'투자수익'**
  String get categoryInvestment;

  /// 카테고리: 기타수입
  ///
  /// In ko, this message translates to:
  /// **'기타수입'**
  String get categoryOtherIncome;

  /// 카테고리: 식비
  ///
  /// In ko, this message translates to:
  /// **'식비'**
  String get categoryFood;

  /// 카테고리: 교통비
  ///
  /// In ko, this message translates to:
  /// **'교통비'**
  String get categoryTransport;

  /// 카테고리: 쇼핑
  ///
  /// In ko, this message translates to:
  /// **'쇼핑'**
  String get categoryShopping;

  /// 카테고리: 문화생활
  ///
  /// In ko, this message translates to:
  /// **'문화생활'**
  String get categoryCulture;

  /// 카테고리: 의료비
  ///
  /// In ko, this message translates to:
  /// **'의료비'**
  String get categoryMedical;

  /// 카테고리: 기타지출
  ///
  /// In ko, this message translates to:
  /// **'기타지출'**
  String get categoryOtherExpense;

  /// 거래 유형
  ///
  /// In ko, this message translates to:
  /// **'구분'**
  String get type;

  /// 금액 유효성 검사 메시지
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력하세요'**
  String get validationAmount;

  /// 정수 유효성 검사 메시지
  ///
  /// In ko, this message translates to:
  /// **'올바른 정수를 입력하세요'**
  String get validationInteger;

  /// 거래 ID 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 ID를 찾을 수 없습니다'**
  String get errorTransactionIdNotFound;

  /// 거래 수정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 수정되었습니다'**
  String get successTransactionUpdated;

  /// 거래 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 저장되었습니다'**
  String get successTransactionSaved;

  /// 거래 삭제 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'거래 내역 삭제'**
  String get deleteTransaction;

  /// 거래 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'{category} 거래 내역을 삭제하시겠습니까?'**
  String deleteTransactionConfirm(String category);

  /// 거래 삭제 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 삭제되었습니다'**
  String get successTransactionDeleted;

  /// 삭제 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'삭제 중 오류가 발생했습니다'**
  String get errorDeleting;

  /// 캘린더 월간 보기
  ///
  /// In ko, this message translates to:
  /// **'월간'**
  String get calendarMonthly;

  /// 캘린더 주간 보기
  ///
  /// In ko, this message translates to:
  /// **'주간'**
  String get calendarWeekly;

  /// 일요일
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get sunday;

  /// 월요일
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get monday;

  /// 화요일
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get tuesday;

  /// 수요일
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get wednesday;

  /// 목요일
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get thursday;

  /// 금요일
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get friday;

  /// 토요일
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get saturday;

  /// 주간 합계
  ///
  /// In ko, this message translates to:
  /// **'주간 합계'**
  String get weeklyTotal;

  /// 테마 설정
  ///
  /// In ko, this message translates to:
  /// **'테마'**
  String get theme;

  /// 시스템 기본 테마
  ///
  /// In ko, this message translates to:
  /// **'시스템 기본'**
  String get themeSystem;

  /// 라이트 테마
  ///
  /// In ko, this message translates to:
  /// **'라이트'**
  String get themeLight;

  /// 다크 테마
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get themeDark;

  /// 화폐 단위: 원
  ///
  /// In ko, this message translates to:
  /// **'원'**
  String get currencyWon;

  /// 천 단위
  ///
  /// In ko, this message translates to:
  /// **'천'**
  String get currencyThousand;

  /// 만 단위
  ///
  /// In ko, this message translates to:
  /// **'만'**
  String get currencyTenThousand;

  /// 통화 단위 설정
  ///
  /// In ko, this message translates to:
  /// **'통화 단위'**
  String get currencyUnit;

  /// 한국 원화
  ///
  /// In ko, this message translates to:
  /// **'대한민국 원 (₩)'**
  String get currencyKRW;

  /// 미국 달러
  ///
  /// In ko, this message translates to:
  /// **'미국 달러 (\$)'**
  String get currencyUSD;

  /// 로그인
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get login;

  /// 회원가입
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get signup;

  /// 이메일
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get email;

  /// 비밀번호
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get password;

  /// 이름
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get name;

  /// 로그인 환영 메시지
  ///
  /// In ko, this message translates to:
  /// **'다시 오신 것을 환영합니다'**
  String get welcomeBack;

  /// 회원가입 타이틀
  ///
  /// In ko, this message translates to:
  /// **'계정 만들기'**
  String get createAccount;

  /// 계정 연결
  ///
  /// In ko, this message translates to:
  /// **'계정 연결'**
  String get linkAccount;

  /// 게스트 로그인
  ///
  /// In ko, this message translates to:
  /// **'게스트로 계속하기'**
  String get continueAsGuest;

  /// 계정 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'계정이 없으신가요?'**
  String get dontHaveAccount;

  /// 계정 있음 메시지
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있으신가요?'**
  String get alreadyHaveAccount;

  /// 이메일 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'이메일 주소를 입력하세요'**
  String get enterEmail;

  /// 비밀번호 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력하세요'**
  String get enterPassword;

  /// 이름 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력하세요'**
  String get enterName;

  /// 이메일 유효성 검사
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 주소를 입력하세요'**
  String get validationEmail;

  /// 비밀번호 유효성 검사
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 최소 6자 이상이어야 합니다'**
  String get validationPassword;

  /// 이름 유효성 검사
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력하세요'**
  String get validationName;

  /// 빈 입력값 에러
  ///
  /// In ko, this message translates to:
  /// **'입력값이 비어있습니다'**
  String get validationEmpty;

  /// 로그인 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인 성공!'**
  String get successfullyLoggedIn;

  /// 사용자 UID 라벨
  ///
  /// In ko, this message translates to:
  /// **'현재 사용자 UID'**
  String get currentUserUID;

  /// 익명 사용자
  ///
  /// In ko, this message translates to:
  /// **'익명 사용자'**
  String get anonymousUser;

  /// 대시보드
  ///
  /// In ko, this message translates to:
  /// **'대시보드'**
  String get dashboard;

  /// 준비중 메시지
  ///
  /// In ko, this message translates to:
  /// **'곧 출시될 기능입니다!'**
  String get featureComingSoon;

  /// 계정 연결 설명
  ///
  /// In ko, this message translates to:
  /// **'익명 계정을 이메일과 비밀번호로 연결하세요'**
  String get linkAccountDescription;

  /// 계정 연결 성공
  ///
  /// In ko, this message translates to:
  /// **'계정이 성공적으로 연결되었습니다!'**
  String get accountLinkedSuccess;

  /// 인증 오류
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get errorOccurredAuth;

  /// 사용자 없음 에러
  ///
  /// In ko, this message translates to:
  /// **'해당 이메일의 사용자를 찾을 수 없습니다'**
  String get errorUserNotFound;

  /// 잘못된 비밀번호 에러
  ///
  /// In ko, this message translates to:
  /// **'잘못된 비밀번호입니다'**
  String get errorWrongPassword;

  /// 잘못된 이메일 에러
  ///
  /// In ko, this message translates to:
  /// **'올바르지 않은 이메일 주소입니다'**
  String get errorInvalidEmail;

  /// 약한 비밀번호 에러
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 너무 약합니다'**
  String get errorWeakPassword;

  /// 이메일 중복 에러
  ///
  /// In ko, this message translates to:
  /// **'이미 사용중인 이메일입니다'**
  String get errorEmailInUse;

  /// 제공자 중복 에러
  ///
  /// In ko, this message translates to:
  /// **'이미 연결된 제공자입니다'**
  String get errorProviderLinked;

  /// 잘못된 인증 정보
  ///
  /// In ko, this message translates to:
  /// **'인증 정보가 유효하지 않습니다'**
  String get errorInvalidCredential;

  /// 인증 정보 중복 사용
  ///
  /// In ko, this message translates to:
  /// **'이 인증 정보는 이미 다른 계정에 연결되어 있습니다'**
  String get errorCredentialInUse;

  /// 로그인 안됨 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인된 사용자가 없습니다'**
  String get noUserLoggedIn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
