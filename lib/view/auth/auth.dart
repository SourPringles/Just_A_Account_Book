import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'link.dart';
import '../uivalue/ui_layout.dart';
import '../uivalue/ui_text.dart';
import '../uivalue/ui_colors.dart';

class AuthWidget extends StatelessWidget {
  final User? user;

  const AuthWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Successfully logged in!",
          style: UIText.largeTextStyle(context),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: UILayout.dynamicVerticalSpacing(context)),
        _buildUserInfo(context),
        SizedBox(height: UILayout.dynamicVerticalSpacing(context)),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final smallSpacing = UILayout.smallVerticalSpacing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current User UID:",
          style: UIText.mediumTextStyle(context),
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
            user?.uid ?? "No UID available",
            style: UIText.smallTextStyle(
              context,
            ).copyWith(fontFamily: 'monospace'),
          ),
        ),
        SizedBox(height: smallSpacing),
        if (user?.isAnonymous == true)
          Text(
            "(Anonymous User)",
            style: UIText.smallTextStyle(context).copyWith(
              fontSize: UIText.smallFontSize + 2,
              color: UIColors.warningColor,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (user?.isAnonymous == false && user?.email != null)
          Text(
            "Email: ${user!.email}",
            style: UIText.smallTextStyle(
              context,
            ).copyWith(fontSize: UIText.smallFontSize + 2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttonPadding = UILayout.buttonPadding(context);
    final buttonSpacing = UILayout.buttonSpacing(context);
    final iconSize = UILayout.isNarrow(context) ? 18.0 : UILayout.iconSizeLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (user?.isAnonymous == true) ...[
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
              "Link Account",
              style: UIText.mediumTextStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: buttonSpacing),
        ],
        ElevatedButton.icon(
          onPressed: () {
            // 추가 기능을 위한 플레이스홀더
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Feature coming soon!")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: UIColors.incomeColor,
            foregroundColor: UIColors.whiteColor,
            padding: EdgeInsets.symmetric(vertical: buttonPadding),
          ),
          icon: Icon(Icons.dashboard, size: iconSize),
          label: Text(
            "Dashboard",
            style: UIText.mediumTextStyle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
