import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'link.dart';

class AuthWidget extends StatelessWidget {
  final User? user;

  const AuthWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = _getTitleFontSize(screenWidth);

    return Column(
      children: [
        Text(
          "Successfully logged in!",
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _getVerticalSpacing(screenWidth)),
        _buildUserInfo(context),
        SizedBox(height: _getVerticalSpacing(screenWidth)),
        _buildActionButtons(context),
      ],
    );
  }

  double _getTitleFontSize(double screenWidth) {
    if (screenWidth < 350) {
      return 16.0; // 매우 작은 화면
    } else if (screenWidth < 400) {
      return 18.0; // 작은 화면
    } else if (screenWidth < 600) {
      return 20.0; // 중간 화면
    } else {
      return 22.0; // 큰 화면
    }
  }

  double _getLabelFontSize(double screenWidth) {
    if (screenWidth < 350) {
      return 14.0;
    } else if (screenWidth < 400) {
      return 15.0;
    } else {
      return 16.0;
    }
  }

  double _getContentFontSize(double screenWidth) {
    if (screenWidth < 350) {
      return 10.0;
    } else if (screenWidth < 400) {
      return 11.0;
    } else {
      return 12.0;
    }
  }

  double _getVerticalSpacing(double screenWidth) {
    if (screenWidth < 400) {
      return 12.0;
    } else {
      return 20.0;
    }
  }

  Widget _buildUserInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = _getLabelFontSize(screenWidth);
    final contentFontSize = _getContentFontSize(screenWidth);
    final smallSpacing = _getVerticalSpacing(screenWidth) * 0.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current User UID:",
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: smallSpacing),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth < 400 ? 8.0 : 12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: SelectableText(
            user?.uid ?? "No UID available",
            style: TextStyle(
              fontSize: contentFontSize,
              fontFamily: 'monospace',
            ),
          ),
        ),
        SizedBox(height: smallSpacing),
        if (user?.isAnonymous == true)
          Text(
            "(Anonymous User)",
            style: TextStyle(
              fontSize: contentFontSize + 2,
              color: Colors.orange,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (user?.isAnonymous == false && user?.email != null)
          Text(
            "Email: ${user!.email}",
            style: TextStyle(fontSize: contentFontSize + 2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonPadding = screenWidth < 400 ? 8.0 : 12.0;
    final buttonSpacing = screenWidth < 400 ? 8.0 : 12.0;
    final buttonTextSize = screenWidth < 400 ? 14.0 : 16.0;
    final iconSize = screenWidth < 400 ? 18.0 : 24.0;

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
              style: TextStyle(fontSize: buttonTextSize),
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
            style: TextStyle(fontSize: buttonTextSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
