import 'package:firebase_auth/firebase_auth.dart';
import 'auth/login.dart';
import 'auth/link.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Firebase App"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async => await FirebaseAuth.instance
                      .signOut()
                      .then((_) => Navigator.pushNamed(context, "/login")),
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return _buildResponsiveBody(context, user.data, constraints);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildResponsiveBody(
    BuildContext context,
    User? user,
    BoxConstraints constraints,
  ) {
    final isWideScreen = constraints.maxWidth > 800;
    final isMediumScreen = constraints.maxWidth > 600;

    if (isWideScreen) {
      return _buildWideScreenLayout(user);
    } else if (isMediumScreen) {
      return _buildMediumScreenLayout(user);
    } else {
      return _buildNarrowScreenLayout(user);
    }
  }

  Widget _buildWideScreenLayout(User? user) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽: 사용자 정보
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "User Information",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildUserInfo(user),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // 오른쪽: 액션 버튼들
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Actions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActionButtons(user),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumScreenLayout(User? user) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildUserInfo(user),
                    const SizedBox(height: 20),
                    _buildActionButtons(user),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNarrowScreenLayout(User? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Successfully logged in!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildUserInfo(user),
          const SizedBox(height: 20),
          _buildActionButtons(user),
        ],
      ),
    );
  }

  Widget _buildUserInfo(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current User UID:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: SelectableText(
            user?.uid ?? "No UID available",
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
        ),
        const SizedBox(height: 12),
        if (user?.isAnonymous == true)
          const Text(
            "(Anonymous User)",
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
              fontStyle: FontStyle.italic,
            ),
          ),
        if (user?.isAnonymous == false && user?.email != null)
          Text("Email: ${user!.email}", style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildActionButtons(User? user) {
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
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.link),
            label: const Text("Link Account"),
          ),
          const SizedBox(height: 12),
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
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: const Icon(Icons.dashboard),
          label: const Text("Dashboard"),
        ),
      ],
    );
  }
}
