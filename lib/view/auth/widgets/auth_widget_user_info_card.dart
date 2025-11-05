import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import '../../uivalue/ui_layout.dart';
import '../../uivalue/ui_text.dart';
import '../../uivalue/ui_colors.dart';

/// 사용자 정보를 표시하는 카드 위젯
class AuthWidgetUserInfoCard extends StatelessWidget {
  final User user;

  const AuthWidgetUserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final smallSpacing = UILayout.smallVerticalSpacing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.currentUserUID,
          style: UIText.mediumTextStyle(context, weight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: smallSpacing),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(UILayout.isNarrow(context) ? 8.0 : 12.0),
          decoration: BoxDecoration(
            color: UIColors.cardBackgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: UIColors.borderColor),
          ),
          child: SelectableText(
            user.uid,
            style: UIText.smallTextStyle(
              context,
            ).copyWith(fontFamily: 'monospace'),
          ),
        ),
        SizedBox(height: smallSpacing),

        // 익명 사용자 표시
        if (user.isAnonymous)
          _buildInfoChip(
            context,
            icon: Icons.person_off,
            label: l10n.anonymousUser,
            color: UIColors.warningColor,
          ),

        // 이메일 표시
        if (!user.isAnonymous && user.email != null)
          _buildInfoChip(
            context,
            icon: Icons.email,
            label: user.email!,
            color: UIColors.incomeColor,
          ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: UIText.smallTextStyle(context).copyWith(
                fontSize: UIText.smallFontSize + 2,
                color: color,
                fontStyle: user.isAnonymous
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
