import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_role.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();

  // 获取当前用户
  User? get currentUser => _auth.currentUser;

  // 监听用户状态变化
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 邮箱密码注册
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await _userService.createUser(
          id: user.uid,
          email: email,
          name: name,
          role: role,
        );
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 邮箱密码登录
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Google登录
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign in aborted';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final existingUser = await _userService.getUser(user.uid);
        if (existingUser == null) {
          await _userService.createUser(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            role: UserRole.student,
          );
        }
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 退出登录
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  // 重置密码
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 处理认证异常
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return '密码强度太弱';
        case 'email-already-in-use':
          return '该邮箱已被注册';
        case 'invalid-email':
          return '邮箱格式不正确';
        case 'user-disabled':
          return '用户账号已被禁用';
        case 'user-not-found':
          return '用户不存在';
        case 'wrong-password':
          return '密码错误';
        case 'too-many-requests':
          return '请求次数过多，请稍后再试';
        default:
          return '认证错误：${e.message}';
      }
    }
    return '发生错误：$e';
  }
}
