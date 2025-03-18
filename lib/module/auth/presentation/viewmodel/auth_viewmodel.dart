import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frog_task_list/global_providers.dart';
import 'package:frog_task_list/module/auth/domain/index.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<UserEntity?>>((ref) {
      return AuthViewModel(ref);
    });

class AuthViewModel extends StateNotifier<AsyncValue<UserEntity?>> {
  final Ref ref;

  AuthViewModel(this.ref) : super(const AsyncValue.loading()) {
    _checkToken();
  }

  Future<void> _checkToken() async {
    try {
      final isValid = await ref.read(checkTokenProvider).call();
      if (isValid) {
        final user = ref.read(authRepositoryProvider).local.getUser();
        state = AsyncValue.data(
          UserEntity(id: user!.id, email: user.email, token: user.token),
        );
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error('Check token failed: $e', stack);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(loginProvider).call(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error('Login failed: $e', stack);
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(registerProvider).call(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error('Register failed: $e', stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(logoutProvider).call();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Logout failed: $e', stack);
    }
  }
}
