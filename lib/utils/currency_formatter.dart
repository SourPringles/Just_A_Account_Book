import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';

/// 다국어를 지원하는 화폐 포맷팅 유틸리티
class CurrencyFormatter {
  /// 금액을 간단한 형태로 포맷 (천/만 단위)
  ///
  /// 한국어: 10000 -> "1만", 1000 -> "1천", 100 -> "100"
  /// 영어: 10000 -> "10K", 1000 -> "1K", 100 -> "100"
  static String formatCompact(num amount, AppLocalizations l10n) {
    if (amount == 0) return '';

    final absAmount = amount.abs();

    // 영어권: 1000 이상은 모두 K로 표시
    if (l10n.currencyTenThousand == l10n.currencyThousand) {
      if (absAmount >= 1000) {
        final value = absAmount / 1000;
        return '${NumberFormat('#.#').format(value)}${l10n.currencyThousand}';
      } else {
        return absAmount.toInt().toString();
      }
    }

    // 한국어: 만/천 단위 구분
    if (absAmount >= 10000) {
      final value = absAmount / 10000;
      return '${NumberFormat('#.#').format(value)}${l10n.currencyTenThousand}';
    } else if (absAmount >= 1000) {
      final value = (absAmount / 1000).toInt();
      return '$value${l10n.currencyThousand}';
    } else {
      return absAmount.toInt().toString();
    }
  }

  /// 금액을 포맷팅 (천/만 단위 + 화폐 단위)
  ///
  /// 한국어: 10000 -> "1만원", 1000 -> "1천원", 100 -> "100원"
  /// 영어: 10000 -> "10K", 1000 -> "1K", 100 -> "100"
  static String formatWithUnit(int amount, AppLocalizations l10n) {
    final absAmount = amount.abs();

    // 영어권: 1000 이상은 모두 K로 표시
    if (l10n.currencyTenThousand == l10n.currencyThousand) {
      if (absAmount >= 1000) {
        final value = absAmount / 1000;
        final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
        return '$formatted${l10n.currencyThousand}${l10n.currencyWon}';
      } else {
        return '$absAmount${l10n.currencyWon}';
      }
    }

    // 한국어: 만/천 단위 구분
    if (absAmount >= 10000) {
      final value = absAmount / 10000;
      final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
      return '$formatted${l10n.currencyTenThousand}${l10n.currencyWon}';
    } else if (absAmount >= 1000) {
      final value = absAmount / 1000;
      final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
      return '$formatted${l10n.currencyThousand}${l10n.currencyWon}';
    } else {
      return '$absAmount${l10n.currencyWon}';
    }
  }

  /// 전체 금액 포맷 (쉼표 포함)
  ///
  /// 예: 1234567 -> "₩1,234,567" (한국어) 또는 "$1,234,567" (영어)
  static String formatFull(num amount) {
    final currencySymbol = SettingsService.instance.currencySymbol.value;
    return '$currencySymbol${NumberFormat('#,###').format(amount)}';
  }
}
