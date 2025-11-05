import 'package:flutter/material.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_text.dart';

class CurrencySectionWidget extends StatelessWidget {
  final String currentCurrency;
  final ValueChanged<String> onCurrencyChanged;

  const CurrencySectionWidget({
    super.key,
    required this.currentCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.currencyUnit, style: UIText.largeTextStyle(context)),
        RadioListTile<String>(
          title: Text(l10n.currencyKRW),
          value: 'KRW',
          groupValue: currentCurrency,
          onChanged: (v) {
            if (v != null) onCurrencyChanged(v);
          },
        ),
        RadioListTile<String>(
          title: Text(l10n.currencyUSD),
          value: 'USD',
          groupValue: currentCurrency,
          onChanged: (v) {
            if (v != null) onCurrencyChanged(v);
          },
        ),
      ],
    );
  }
}
