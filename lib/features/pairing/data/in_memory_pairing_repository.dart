import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
import '../domain/pairing_repository.dart';

class InMemoryPairingRepository implements PairingRepository {
  PairRecord? _currentPair;

  @override
  Future<PairRecord?> getCurrentPair() async {
    return _currentPair;
  }

  @override
  Future<PairRecord> createInviteCode({required AppUser currentUser}) async {
    _currentPair = PairRecord(
      id: 'pair-draft-1',
      memberIds: [currentUser.id],
      status: 'pending',
      inviteCode: 'BEACON',
      partnerDisplayName: 'Sarah',
      expiresInMinutes: 5,
    );
    return _currentPair!;
  }

  @override
  Future<PairRecord> approvePairing({
    required AppUser currentUser,
    String? inviteCode,
  }) async {
    final draft = _currentPair ??
        PairRecord(
          id: 'pair-1',
          memberIds: [currentUser.id],
          status: 'pending',
          inviteCode: 'BEACON',
          partnerDisplayName: 'Sarah',
          expiresInMinutes: 5,
        );

    _currentPair = PairRecord(
      id: 'pair-1',
      memberIds: [currentUser.id, 'user-2'],
      status: 'active',
      inviteCode: inviteCode ?? draft.inviteCode,
      partnerDisplayName: draft.partnerDisplayName,
      expiresInMinutes: draft.expiresInMinutes,
    );

    return _currentPair!;
  }

  @override
  Future<void> skipPairing() async {
    _currentPair = null;
  }
}
