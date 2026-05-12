import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepositoryImpl _repository;
  final Ref _ref;

  ProfileNotifier(this._repository, this._ref) : super(const ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = _ref.read(authProvider).user;
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile({
    String? nom,
    String? phone,
    String? email,
    String? profileImage,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedUser = await _repository.updateProfile(
        nom: nom,
        phone: phone,
        email: email,
        profileImage: profileImage,
      );
      state = state.copyWith(user: updatedUser, isLoading: false);
      _ref.read(authProvider.notifier).logout();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref.watch(profileRepositoryProvider), ref);
});
