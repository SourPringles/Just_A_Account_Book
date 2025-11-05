import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_a_account_book/l10n/app_localizations.dart';
import 'link.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_text.dart';
import '../uivalue/ui_colors.dart';
import 'widgets/auth_widget_user_info_card.dart';

class AuthWidget extends StatelessWidget {
  final User? user;

  const AuthWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      return Center(
        child: Text(
          l10n.noUserLoggedIn,
          style: UIText.mediumTextStyle(context),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(UILayout.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 성공 메시지
          Card(
            elevation: 0,
            color: UIColors.incomeColor.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(UILayout.defaultPadding),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: UIColors.incomeColor,
                    size: UILayout.iconSizeLarge,
                  ),
                  SizedBox(width: UILayout.smallGap),
                  Expanded(
                    child: Text(
                      l10n.successfullyLoggedIn,
                      style: UIText.largeTextStyle(
                        context,
                        weight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: UILayout.largeGap),

          // 사용자 정보 카드
          AuthWidgetUserInfoCard(user: user!),
          SizedBox(height: UILayout.largeGap),

          // 액션 버튼들
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final buttonPadding = UILayout.buttonPadding(context);
    final buttonSpacing = UILayout.buttonSpacing(context);
    final iconSize = UILayout.isNarrow(context) ? 18.0 : UILayout.iconSizeLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 익명 사용자인 경우 계정 연결 버튼 표시
        if (user!.isAnonymous) ...[
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LinkPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UIColors.commonPositiveColor,
              foregroundColor: UIColors.whiteColor,
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
            ),
            icon: Icon(Icons.link, size: iconSize),
            label: Text(
              l10n.linkAccount,
              style: UIText.mediumTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: buttonSpacing),
        ],

        // 대시보드 버튼
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.featureComingSoon)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: UIColors.incomeColor,
            foregroundColor: UIColors.whiteColor,
            padding: EdgeInsets.symmetric(vertical: buttonPadding),
          ),
          icon: Icon(Icons.dashboard, size: iconSize),
          label: Text(
            l10n.dashboard,
            style: UIText.mediumTextStyle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
