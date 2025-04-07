enum UserRole {
  student('学生'),
  teacher('教师');

  final String displayName;
  const UserRole(this.displayName);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.student,
    );
  }
}
