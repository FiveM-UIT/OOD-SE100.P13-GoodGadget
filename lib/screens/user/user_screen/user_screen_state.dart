import 'package:equatable/equatable.dart';

class UserScreenState with EquatableMixin {
  final String username;
  final String email;
  final String avatarUrl;

  const UserScreenState({
    required this.username,
    required this.email,
    this.avatarUrl = '',
  });

  @override
  List<Object?> get props => [username, email, avatarUrl];

  UserScreenState copyWith({
    String? username,
    String? email,
    String? avatarUrl,
  }) {
    return UserScreenState(
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}