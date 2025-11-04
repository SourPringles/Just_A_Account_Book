import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('통화 단위', style: UIText.largeTextStyle(context)),
        RadioListTile<String>(
          title: const Text('KRW (₩)'),
          value: 'KRW',
          groupValue: currentCurrency,
          onChanged: (v) {
            if (v != null) onCurrencyChanged(v);
          },
        ),
        RadioListTile<String>(
          title: const Text('USD (\$)'),
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
