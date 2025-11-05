// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '가계부';

  @override
  String get refresh => '새로고침';

  @override
  String get settings => '설정';

  @override
  String get accountInfo => '계정 정보';

  @override
  String get transactions => '거래내역';

  @override
  String get summary => '요약';

  @override
  String get addTransaction => '거래 추가';

  @override
  String get income => '수입';

  @override
  String get expense => '지출';

  @override
  String get balance => '잔액';

  @override
  String get category => '카테고리';

  @override
  String get amount => '금액';

  @override
  String get description => '설명 (선택사항)';

  @override
  String get date => '날짜';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get edit => '수정';

  @override
  String get close => '닫기';

  @override
  String get addIncome => '수입 추가';

  @override
  String get addExpense => '지출 추가';

  @override
  String get editIncome => '수입 수정';

  @override
  String get editExpense => '지출 수정';

  @override
  String get deleteConfirmTitle => '거래 삭제';

  @override
  String get deleteConfirmMessage => '이 거래 내역을 삭제하시겠습니까?';

  @override
  String get transactionDeleted => '거래 내역이 삭제되었습니다';

  @override
  String get transactionSaved => '거래 내역이 저장되었습니다';

  @override
  String get transactionUpdated => '거래 내역이 수정되었습니다';

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String get errorSaving => '저장 중 오류가 발생했습니다';

  @override
  String get pleaseEnterAmount => '금액을 입력하세요';

  @override
  String get pleaseEnterValidNumber => '올바른 정수를 입력하세요';

  @override
  String get noTransactionsToday => '오늘 거래 내역이 없습니다';

  @override
  String get noTransactionsThisMonth => '이번 달 거래 내역이 없습니다';

  @override
  String get loginRequired => '로그인이 필요합니다';

  @override
  String get retry => '다시 시도';

  @override
  String get weeklySummary => '주간 합계';

  @override
  String get language => '언어';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get categorySalary => '급여';

  @override
  String get categorySideJob => '부업';

  @override
  String get categoryInvestment => '투자수익';

  @override
  String get categoryOtherIncome => '기타수입';

  @override
  String get categoryFood => '식비';

  @override
  String get categoryTransport => '교통비';

  @override
  String get categoryShopping => '쇼핑';

  @override
  String get categoryCulture => '문화생활';

  @override
  String get categoryMedical => '의료비';

  @override
  String get categoryOtherExpense => '기타지출';

  @override
  String get type => '구분';

  @override
  String get validationAmount => '금액을 입력하세요';

  @override
  String get validationInteger => '올바른 정수를 입력하세요';

  @override
  String get errorTransactionIdNotFound => '거래 ID를 찾을 수 없습니다';

  @override
  String get successTransactionUpdated => '거래 내역이 수정되었습니다';

  @override
  String get successTransactionSaved => '거래 내역이 저장되었습니다';

  @override
  String get deleteTransaction => '거래 내역 삭제';

  @override
  String deleteTransactionConfirm(String category) {
    return '$category 거래 내역을 삭제하시겠습니까?';
  }

  @override
  String get successTransactionDeleted => '거래 내역이 삭제되었습니다';

  @override
  String get errorDeleting => '삭제 중 오류가 발생했습니다';

  @override
  String get calendarMonthly => '월간';

  @override
  String get calendarWeekly => '주간';

  @override
  String get sunday => '일';

  @override
  String get monday => '월';

  @override
  String get tuesday => '화';

  @override
  String get wednesday => '수';

  @override
  String get thursday => '목';

  @override
  String get friday => '금';

  @override
  String get saturday => '토';

  @override
  String get weeklyTotal => '주간 합계';

  @override
  String get theme => '테마';

  @override
  String get themeSystem => '시스템 기본';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get currencyWon => '원';

  @override
  String get currencyThousand => '천';

  @override
  String get currencyTenThousand => '만';

  @override
  String get currencyUnit => '통화 단위';

  @override
  String get currencyKRW => '대한민국 원 (₩)';

  @override
  String get currencyUSD => '미국 달러 (\$)';
}
