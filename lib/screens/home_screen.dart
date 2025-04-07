import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:true_teacher/providers/auth_provider.dart';
import 'package:true_teacher/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole = authProvider.userRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text('True Teacher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body:
          userRole == null
              ? const Center(child: CircularProgressIndicator())
              : _buildRoleSpecificContent(context, userRole),
    );
  }

  Widget _buildRoleSpecificContent(BuildContext context, String role) {
    switch (role) {
      case 'student':
        return _buildStudentContent();
      case 'teacher':
        return _buildTeacherContent();
      default:
        return const Center(child: Text('未知角色'));
    }
  }

  Widget _buildStudentContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 100),
          SizedBox(height: 20),
          Text('欢迎来到学习中心', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text('开始您的学习之旅吧！'),
        ],
      ),
    );
  }

  Widget _buildTeacherContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 100),
          SizedBox(height: 20),
          Text('欢迎来到教学中心', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text('开始分享您的知识吧！'),
        ],
      ),
    );
  }
}
