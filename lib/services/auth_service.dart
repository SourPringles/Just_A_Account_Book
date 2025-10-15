import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 사용자 가져오기
  static User? get currentUser => _auth.currentUser;

  // 인증 상태 변화 스트림
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 이메일/비밀번호로 회원가입
  static Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Firebase Auth에 사용자 생성
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Firestore에 사용자 프로필 저장
      if (userCredential.user != null) {
        await _createUserProfile(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.code} - ${e.message}');
      throw e;
    }
  }

  // 이메일/비밀번호로 로그인
  static Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 마지막 로그인 시간 업데이트
      if (userCredential.user != null) {
        await _updateLastLoginTime(userCredential.user!.uid);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.code} - ${e.message}');
      throw e;
    }
  }

  // 익명 로그인
  static Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      // 익명 사용자도 프로필 생성
      if (userCredential.user != null) {
        await _createUserProfile(
          uid: userCredential.user!.uid,
          email: 'anonymous@temp.com',
          name: '임시 사용자',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Anonymous sign in error: ${e.code} - ${e.message}');
      throw e;
    }
  }

  // 로그아웃
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // 사용자 프로필 생성
  static Future<void> _createUserProfile({
    required String uid,
    required String email,
    required String name,
  }) async {
    try {
      final userProfile = UserProfile(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userProfile.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  // 마지막 로그인 시간 업데이트
  static Future<void> _updateLastLoginTime(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLoginAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error updating last login time: $e');
    }
  }

  // 사용자 프로필 가져오기
  static Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // 사용자 프로필 업데이트
  static Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? currency,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (currency != null) updates['currency'] = currency;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updates);
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }
}
