import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'link.dart';
import '../uivalue.dart';

class AuthWidget extends StatelessWidget {
  final User? user;

  const AuthWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Successfully logged in!",
          style: UIValue.titleStyle(context),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: UIValue.dynamicVerticalSpacing(context)),
        _buildUserInfo(context),
        SizedBox(height: UIValue.dynamicVerticalSpacing(context)),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final smallSpacing = UIValue.smallVerticalSpacing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current User UID:",
          style: UIValue.labelStyle(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: smallSpacing),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(UIValue.isNarrow(context) ? 8.0 : 12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: SelectableText(
            user?.uid ?? "No UID available",
            style: UIValue.contentStyle(
              context,
            ).copyWith(fontFamily: 'monospace'),
          ),
        ),
        SizedBox(height: smallSpacing),
        if (user?.isAnonymous == true)
          Text(
            "(Anonymous User)",
            style: UIValue.contentStyle(context).copyWith(
              fontSize: UIValue.smallFontSize + 2,
              color: Colors.orange,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (user?.isAnonymous == false && user?.email != null)
          Text(
            "Email: ${user!.email}",
            style: UIValue.contentStyle(
              context,
            ).copyWith(fontSize: UIValue.smallFontSize + 2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttonPadding = UIValue.buttonPadding(context);
    final buttonSpacing = UIValue.buttonSpacing(context);
    final iconSize = UIValue.isNarrow(context) ? 18.0 : UIValue.iconSizeLarge;

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
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
            ),
            icon: Icon(Icons.link, size: iconSize),
            label: Text(
              "Link Account",
              style: UIValue.buttonStyle(context),
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
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: buttonPadding),
          ),
          icon: Icon(Icons.dashboard, size: iconSize),
          label: Text(
            "Dashboard",
            style: UIValue.buttonStyle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
